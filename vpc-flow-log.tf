// VPC FLOW LOG
resource "aws_flow_log" "this" {
  iam_role_arn             = aws_iam_role.vpc_flow_log_cloudwatch.arn
  log_destination          = aws_cloudwatch_log_group.flow_log.arn
  traffic_type             = upper(var.flow_log_traffic_type)
  vpc_id                   = aws_vpc.this.id
  max_aggregation_interval = var.flow_log_max_aggregation_interval
  tags                     = var.tags
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = var.flow_log_cloudwatch_log_group_name
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_id
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  name               = var.flow_log_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    sid    = "AWSVPCFlowLogsAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid    = "AWSVPCFlowLogsPushToCloudWatch"
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

resource "aws_iam_role_policy" "vpc_flow_log_cloudwatch" {
  name   = "${var.env}-${var.name}-flow-log-policy"
  role   = aws_iam_role.vpc_flow_log_cloudwatch.name
  policy = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}
