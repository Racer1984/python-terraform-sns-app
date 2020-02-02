output "SNS_TOPIC_ARN" {
  value     = aws_sns_topic.topic_with_subscription.arn
}

output "NAT_GW_IP" {
  value     = aws_eip.eip.public_ip
}

output "APPLICATION_URL" {
  value     = format("http://%s", aws_lb.sns-app-alb.dns_name)
}