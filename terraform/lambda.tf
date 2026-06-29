data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }

}

resource "aws_iam_role" "soc_lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "soc_lambda_policy" {

  name = "${var.project_name}-lambda-policy"

  description = "SOC Incident Processor"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [

          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"

        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [

          "sns:Publish"

        ]

        Resource = aws_sns_topic.security_alerts.arn
      },

      {
        Effect = "Allow"

        Action = [

          "bedrock:InvokeModel"

        ]

        Resource = "*"
      }

    ]
  })
}


resource "aws_lambda_function" "soc_incident_processor" {

  function_name = "${var.project_name}-incident-processor"

  filename = "../lambda/lambda.zip"

  source_code_hash = filebase64sha256("../lambda/lambda.zip")

  role = aws_iam_role.soc_lambda_role.arn

  handler = "app.lambda_handler"

  runtime = "python3.12"

  timeout = 30

  memory_size = 512

  environment {

    variables = {

      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn

    }

  }

}

resource "aws_iam_role_policy_attachment" "soc_lambda_attachment" {
  role = aws_iam_role.soc_lambda_role.name

  policy_arn = aws_iam_policy.soc_lambda_policy.arn

}

resource "aws_lambda_function" "soc_incident_report" {
  function_name = "${var.project_name}-incident-report"

  filename = "../lambda/lambda.zip"

  source_code_hash = filebase64sha256("../lambda/lambda.zip")

  role = aws_iam_role.soc_lambda_role.arn

  handler = "app.lambda_handler"

  runtime = "python3.12"

  timeout = 30

  memory_size = 512

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn
    }
  }
}
