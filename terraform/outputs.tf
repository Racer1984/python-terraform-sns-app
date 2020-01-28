output "sns_topic_arn" {
  value = join("", aws_sns_topic.topic_with_subscription.*.arn)
}