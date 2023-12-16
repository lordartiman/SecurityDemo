resource "aws_ecr_repository" "security_demo_webapp" {
  name                 = "securitydemowebapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  // Optional: Define repository policy, lifecycle policy, etc.
}
