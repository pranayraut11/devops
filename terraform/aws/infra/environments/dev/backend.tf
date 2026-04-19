terraform {
  backend "s3" {
    bucket = "terraform-state-files-pranay"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}