variable "profile" {
  type        = string
  description = "The profile name holding AWS credentials"
  default     = "sns-profile"
}
variable "region" {
  type        = string
  description = "The region for the infrastructure deployment"
  default     = "us-east-2"
}
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for instances"
  defaut      = "ami-05c4c8a3a43951b1d"
}

variable "vpc_cidr" {
  type        = string
  description = "The subnet used for VPC addressing scheme"
  default     = "10.200.0.0/16"
}

variable "public_numbers" {
  description = "Map from AZ to prefix for public subnet"
  default     = {
    "az"      = "us-east-2a"
    "network" = 1
  }
}

variable "private_numbers" {
  description = "Map from AZ to prefix for private subnet"
  default     = {
    "az"      = "us-east-2c"
    "network" = 2
  }
}

variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
  default     = "test-sns"
}

variable "sns_subscription_email_address_list" {
  type        = string
  description = "List of email addresses as a string, space is separator"
  default     = "kir_rus@mail.ru kirill.rusin@gmail.com"
}