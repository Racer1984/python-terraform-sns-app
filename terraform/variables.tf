variable "profile" {
  type        = string
  description = "The profile name holding AWS credentials"
}
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

variable "sns_topic_name" {
  type = string
  description = "SNS topic name"
  default = "p1_messages"
}

variable "sns_subscription_email_address_list" {
  type = string
  description = "List of email addresses as a string, space is separator"
  default = "kir_rus@mail.ru kirill.rusin@gmail.com"
}