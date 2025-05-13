resource "aws_ecr_repository" "app" {
  name                 = "${var.app_name}-repository"
  image_tag_mutability = "MUTABLE"

  tags = merge(
    {
      Environment = var.environment
      Terraform   = "true"
    },
    var.tags,
  )
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 30 days except for tagged images",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}