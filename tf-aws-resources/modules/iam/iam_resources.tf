variable "suffix" {}

# Create IAM role with no permissions
resource "aws_iam_role" "prod_role" {
  name               = "prod-${var.suffix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

# Create IAM policy allowing to assume the role
resource "aws_iam_policy" "prod_policy" {
  name        = "prod-${var.suffix}-policy"
  description = "Policy allowing users or entities to assume the role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = aws_iam_role.prod_role.arn,
      },
    ],
  })
}

# Create IAM group with the above policy attached
resource "aws_iam_group" "prod_group" {
  name = "prod-${var.suffix}-group"
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "prod_group_policy_attachment" {
  group      = aws_iam_group.prod_group.name
  policy_arn = aws_iam_policy.prod_policy.arn
}

# Create IAM user belonging to the above group
resource "aws_iam_user" "prod_user" {
  name = "prod-${var.suffix}-user"
}

# Add users to group
resource "aws_iam_user_group_membership" "prod_user_group_membership" {
  user   = aws_iam_user.prod_user.name
  groups = [aws_iam_group.prod_group.name]
}

data "aws_caller_identity" "current" {}
