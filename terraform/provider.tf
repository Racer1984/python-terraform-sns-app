provider "aws" {
  profile = var.profile
  shared_credentials_file = "$HOME/.aws/credentials"
  region = var.region
}