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

# deployKF
resource "aws_iam_group" "kubeflow-pipelines-backend" {
  name = "kubeflow-pipelines-backend"
}

data "aws_iam_policy_document" "kubeflow-pipelines-backend" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.kubeflow_pipelines_bucket}"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${var.kubeflow_pipelines_bucket}/artifacts/*",
      "arn:aws:s3:::${var.kubeflow_pipelines_bucket}/pipelines/*",
      "arn:aws:s3:::${var.kubeflow_pipelines_bucket}/v2/artifacts/*"
    ]
  }
}

resource "aws_iam_group_policy" "kubeflow-pipelines-backend" {
  name = "kubeflow-pipelines-backend"
  group = aws_iam_group.kubeflow-pipelines-backend.name
  policy = data.aws_iam_policy_document.kubeflow-pipelines-backend.json
}

resource "aws_iam_user" "kubeflow-pipelines-backend" {
  name = "kubeflow-pipelines-backend"
}

resource "aws_iam_user_group_membership" "kubeflow-pipelines-backend" {
  user = aws_iam_user.kubeflow-pipelines-backend.name
  groups = [aws_iam_group.kubeflow-pipelines-backend.name]
}
