// VPC FLOW LOG
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = upper(var.flow_log_traffic_type)
  vpc_id          = aws_vpc.this.id
}
resource "aws_cloudwatch_log_group" "this" {
  name = var.aws_cloudwatch_log_group
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "this" {
  name               = var.vpc_flow_log_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.env}-${var.name}-flow-log-policy"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}
