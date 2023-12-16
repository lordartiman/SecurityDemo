resource "aws_ecs_cluster" "securitywebappdemo_cluster" {
  name = "securitywebappdemo-cluster"
}

resource "aws_ecr_repository" "securitywebappdemo_repo" {
  name = "securitywebappdemo-repo"
}

resource "aws_ecs_task_definition" "securitywebappdemo_task" {
  family                   = "securitywebappdemo-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.fargate_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "securitywebappdemo-app",
    image = "667277165013.dkr.ecr.us-east-1.amazonaws.com/securitydemowebapp:latest",
    portMappings = [{
      containerPort = 3000,
      hostPort      = 3000
    }],
    environment = [
      {
        name  = "DEPLOYMENT_TIME",
        value = "${timestamp()}"
      }
    ]
  }])
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs-tasks-sg"
  description = "Allow ECS tasks to access ECR and other services"
  vpc_id      = aws_vpc.securitywebappdemo_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for TCP port 3000 from anywhere
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for HTTP (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "securitywebappdemo_service" {
  name            = "securitywebappdemo-service"
  cluster         = aws_ecs_cluster.securitywebappdemo_cluster.id
  task_definition = aws_ecs_task_definition.securitywebappdemo_task.arn
  launch_type     = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets = [aws_subnet.securitywebappdemo_subnet1.id, aws_subnet.securitywebappdemo_subnet2.id]
    security_groups = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true  // Set to true if you want the tasks to have public IPs
  }

  // ... other configuration ...
}

