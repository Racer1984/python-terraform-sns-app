#!/bin/sh

for email in $sns_emails; do
  echo $email
  aws sns subscribe --profile "$aws_profile" --region "$aws_region" --topic-arn "$sns_arn" --protocol email --notification-endpoint "$email"
done