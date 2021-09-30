data "aws_vpc" "main" {
  tags = {
    Name = "Main"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Type = "Public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Type = "Public"
  }
}

resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"
}


resource "aws_security_group" "service_security_group" {
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [] #[aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service-sg"
    Environment = var.app_environment
  }
}

#resource "aws_alb" "application_load_balancer" {
#  name               = "${var.app_name}-${var.app_environment}-alb"
#  internal           = false
#  load_balancer_type = "application"
#  subnets            = data.aws_subnet_ids.public.ids
#  security_groups    = [aws_security_group.load_balancer_security_group.id]
#
#  tags = {
#    Name        = "${var.app_name}-alb"
#    Environment = var.app_environment
#  }
#}
#
#resource "aws_security_group" "load_balancer_security_group" {
#  vpc_id = data.aws_vpc.main.id
#
#  ingress {
#    from_port        = 80
#    to_port          = 80
#    protocol         = "tcp"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#  tags = {
#    Name        = "${var.app_name}-sg"
#    Environment = var.app_environment
#  }
#}
#
#resource "aws_lb_target_group" "target_group" {
#  name        = "${var.app_name}-${var.app_environment}-tg"
#  port        = 80
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = data.aws_vpc.main.id
#
#  health_check {
#    healthy_threshold   = "3"
#    interval            = "300"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = "/v1/status"
#    unhealthy_threshold = "2"
#  }
#
#  tags = {
#    Name        = "${var.app_name}-lb-tg"
#    Environment = var.app_environment
#  }
#}
#
#resource "aws_lb_listener" "listener" {
#  load_balancer_arn = aws_alb.application_load_balancer.id
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.target_group.id
#  }
#}

#module "ecs_push_pipeline" {
#  source = "cloudposse/ecs-codepipeline/aws"
#  # Cloud Posse recommends pinning every module to a specific version
#  # version = "x.x.x"
#  name                  = "app"
#  namespace             = "eg"
#  stage                 = "prod"
#  github_oauth_token    = local.github_tokens.github_oauth_token
#  github_webhooks_token = local.github_tokens.github_webhooks_token
#  repo_owner            = "r4h4"
#  repo_name             = "example"
#  branch                = "main"
#  service_name          = "example"
#  ecs_cluster_name      = "eg-staging-example-cluster"
#  privileged_mode       = "true"
#}
