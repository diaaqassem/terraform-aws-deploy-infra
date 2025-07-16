terraform {
  backend "s3" {
    bucket = "fp-iti01"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "state-lock"
  }
}
