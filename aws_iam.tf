
# IAM Role for 'External' lambda which has access to
# CloudWatch, SNS, and RDS.
resource "aws_iam_role" "rds_external_lambda" {
  name = "RDSExternal"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM Role for 'Internal' lambda which has access to
# CloudWatch and VPC behaviour.
resource "aws_iam_role" "rds_internal_lambda" {
  name = "RDSInternal"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rds_internal" {
  name   = "RDSInternalNotifications"
  role   = aws_iam_role.rds_internal_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role_policy" "rds_sps" {
  name   = "readrdspassword"
  role   = aws_iam_role.rds_internal_lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
              "ssm:GetParameters",
              "ssm:GetParameter"],
            "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds/postgres/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "rds_external" {
  name   = "RDSExternalNotifications"
  role   = aws_iam_role.rds_external_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "rds:DescribeDBInstances",
      "sns:Publish"
    ],
    "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rds_lambda_vpc" {
  role       = aws_iam_role.rds_internal_lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
