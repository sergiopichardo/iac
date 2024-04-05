resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-039faoiejfaoi"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
