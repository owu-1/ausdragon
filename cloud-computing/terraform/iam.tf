resource "aws_iam_group" "kops" {
  name = "kops"
}

resource "aws_iam_group_policy_attachment" "kops" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  ])
  
  group = aws_iam_group.kops.name
  policy_arn = each.value
}

resource "aws_iam_user" "kops" {
  name = "kops"
}

resource "aws_iam_user_group_membership" "kops" {
  user = aws_iam_user.kops.name
  groups = [aws_iam_group.kops.name]
}
