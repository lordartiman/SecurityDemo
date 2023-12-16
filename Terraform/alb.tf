# Security Group for ALB
resource "aws_security_group" "securitywebappdemo_alb_sg" {
  name        = "securitywebappdemo-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.securitywebappdemo_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitywebappdemo-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "securitywebappdemo_alb" {
  name               = "securitywebappdemo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.securitywebappdemo_alb_sg.id]
  subnets            = [aws_subnet.securitywebappdemo_subnet1.id, aws_subnet.securitywebappdemo_subnet2.id]

  tags = {
    Name = "securitywebappdemo-alb"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "securitywebappdemo_tg" {
  name     = "securitywebappdemo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.securitywebappdemo_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }
}

# ALB Listener
resource "aws_lb_listener" "securitywebappdemo_listener" {
  load_balancer_arn = aws_lb.securitywebappdemo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.securitywebappdemo_tg.arn
  }
}
