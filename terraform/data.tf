data "terraform_remote_state" "remote_state" {
  backend = "s3"
  config = {
    bucket = "remote-state.bucket"
    key = "hosted_zone/terraform.tfstate"
    region = "eu-central-1"
   }
}