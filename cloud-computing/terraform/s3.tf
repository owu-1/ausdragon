resource "aws_s3_bucket" "state-store" {
  bucket = var.state_store_bucket

  tags = {
    Name = "kops-state-store"
  }
}

resource "aws_s3_bucket_versioning" "state-store" {
  bucket = aws_s3_bucket.state-store.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "oidc-store" {
  bucket = var.oidc_store_bucket

  tags = {
    Name = "kops-oidc-store"
  }
}

resource "aws_s3_bucket_ownership_controls" "oidc-store" {
  bucket = aws_s3_bucket.oidc-store.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "oidc-store" {
  bucket = aws_s3_bucket.oidc-store.id
}

resource "aws_s3_bucket_acl" "oidc-store" {
  depends_on = [
    aws_s3_bucket_ownership_controls.oidc-store,
    aws_s3_bucket_public_access_block.oidc-store
  ]
  bucket = aws_s3_bucket.oidc-store.id
  acl = "public-read"
}

# deployKF
resource "aws_s3_bucket" "kubeflow-pipelines" {
  bucket = var.kubeflow_pipelines_bucket

  tags = {
    Name = "kubeflow-pipelines"
  }
}
