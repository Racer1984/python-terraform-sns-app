resource "aws_iam_role" "AllowSNS_AllowSSM" {
  name = "AllowSNS_AllowSSM"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "AllowSNS_AllowSSM-instanceprofile" {
  name = "AllowSNS_AllowSSM-instanceprofile"
  role = aws_iam_role.AllowSNS_AllowSSM.name
}

resource "aws_iam_role_policy" "AllowSNS_AllowSSM-policy" {
  name = "AllowSNS_AllowSSM-Policy"
  role = aws_iam_role.AllowSNS_AllowSSM.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}