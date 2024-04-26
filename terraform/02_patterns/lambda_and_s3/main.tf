variable "lambda_function_name" {
  default = "python_terraform_lambda"
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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_function_archive" {
  type = "zip"
  source_file = "${path.module}/mylambda.py"
  output_path = "${path.module}/lambda_function_src.zip"
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

data "aws_iam_policy_document" "lambda_access_to_s3" {
    statement {
      effect = "Allow" 

      actions = [
        "s3:GetObject"
      ]

      resources = ["${aws_s3_bucket.images_s3_bucket.arn}/*"]
    }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_cloudwatch_log_group" "terraform_lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_lambda_function" "python_terraform_lambda" {
  function_name = var.lambda_function_name
  filename      = "lambda_function_src.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "python3.10"
  handler       = "mylambda.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_archive.output_base64sha256
  ephemeral_storage {
    size = 1024   # Min 512 MB and the Max 10240 MB
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

resource "random_string" "random" {
    length = 8
    special = false # set to false to avoid special chars in the s3 name
    upper = false # set to false to keep the name lowercase, which is a common practice 
    lower = true 
    numeric = true 
}

variable "images_s3_bucket_name" {
    default = "images-s3-bucket"
}

resource "aws_s3_bucket" "images_s3_bucket" {
  bucket = "${var.images_s3_bucket_name}-${random_string.random.result}"

  tags = {
    Name   = "${var.images_s3_bucket_name}-${random_string.random.result}"
    Environment = "Dev"
  }
}