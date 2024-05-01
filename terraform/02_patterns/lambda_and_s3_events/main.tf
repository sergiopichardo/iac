variable "lambda_function_name" {
  default = "python_terraform_lambda"
}

variable "images_s3_bucket_name" {
  default = "images-s3-bucket"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "lambda_s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.images_s3_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda_s3_access"
  path        = "/"
  description = "IAM policy for accessing S3 from a lambda"
  policy      = data.aws_iam_policy_document.lambda_s3_access.json

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_iam_role_policy_attachment "lambda_s3_access" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_cloudwatch_log_group" "terraform_lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14

  lifecycle {
    create_before_destroy = true
  }
}

data "archive_file" "lambda_function_archive" {
  type         = "zip"
  source_file  = "${path.module}/mylambda.py"
  output_path  = "${path.module}/lambda_function_src.zip"
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "aws_s3_bucket" "images_s3_bucket" {
  bucket = "${var.images_s3_bucket_name}-${random_string.random.result}"

  force_destroy = true

  tags = {
    Name        = "${var.images_s3_bucket_name}-${random_string.random.result}"
    Environment = "Dev"
  }
}

resource "aws_lambda_function" "python_terraform_lambda" {
  function_name    = "${var.lambda_function_name}-${random_string.random.result}"
  filename         = "lambda_function_src.zip"
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.10"
  handler          = "mylambda.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_archive.output_base64sha256

  ephemeral_storage {
    size = 1024
  }

  timeout = 10

  logging_config {
    log_format = "Text"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.terraform_lambda_log_group
  ]
}

# Gives an external source like S3 permission to access the lambda function 
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_terraform_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images_s3_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.images_s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.python_terraform_lambda.arn
    events              = [
      "s3:ObjectCreated:*"
    ]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}


# Add multiple 
# https://stackoverflow.com/questions/45486041/how-to-attach-multiple-iam-policies-to-iam-roles-using-terraform