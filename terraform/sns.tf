resource "aws_sns_topic" "topic_with_subscription" {
  name               = var.sns_topic_name
  provisioner "local-exec" {
    command          = "sh sns_subscription.sh"
    environment      = {
      sns_arn        = self.arn
      sns_emails     = var.sns_subscription_email_address_list
      aws_region     = var.region
      aws_profile    = var.profile
    }
  }
}

resource "aws_ssm_parameter" "topic-arn" {
  name               = "topic-arn"
  type               = "String"
  value              = aws_sns_topic.topic_with_subscription.arn
}