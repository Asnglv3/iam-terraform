resource "aws_iam_user" "user" {
  name = var.iam_user
}

resource "aws_iam_role" "access_role" {
  for_each = toset(var.iam_role)
  name     = each.value

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

output "role" {
  value = aws_iam_role.access_role
}

resource "aws_iam_policy_attachment" "ec2-read" {
  for_each   = toset(var.iam_role)
  name       = "EC2ReadOnly"
  users      = [aws_iam_user.user.name]
  roles      = [role[each.key].name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# resource "aws_iam_policy_attachment" "s3-full" {
#   for_each   = toset(var.iam_role)
#   name       = "S3FullAccess"
#   users      = [aws_iam_user.user.name]
#   roles      = [aws_iam_role.access_role[each.key].name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "admin" {
#   role       = aws_iam_role.access_role[each.key]
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }