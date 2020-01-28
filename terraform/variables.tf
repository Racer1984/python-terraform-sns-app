variable "region" {
  type        = string
  description = "The region for the infrastructure deployment"
}
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the instance."
}

variable "vpc_cidr" {
  type        = string
  description = "The subnet used for VPC addressing scheme."
}

variable "public_numbers" {
  description = "Map from AZ to prefix for public subnet"
  default     = {
    "az" = "us-east-2a"
    "network" = 1
  }
}

variable "private_numbers" {
  description = "Map from AZ to prefix for private subnet"
  default     = {
    "az" = "us-east-2c"
    "network" = 2
  }
}