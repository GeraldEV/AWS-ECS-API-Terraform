# AWS Identity Access Management (IAM)

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.project_name}ECSTaskExecRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name = "${var.project_name} ECS TaskExecRole"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExectuionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

