

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
  source_file = "${path.module}/../src/lambda.py"
  output_path = "${path.module}/lambda_function_src.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_src.zip"
  function_name = "test_lambda"
  role          = aws_iam_role.iam_for_lambda.arn

  runtime       = "python3.10"
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda_function_archive.output_base64sha256

  ephemeral_storage {
    size = 10240 # Min 512 MB and the Max 10240 MB
  }
}