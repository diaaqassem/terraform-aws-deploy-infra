# Public ALB 
resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.proxy_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "public-alb"
  }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "frontend_attachment" {
  count            = length(var.proxy_instance_ids)
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.proxy_instance_ids[count.index]
  port             = 3000
}


# Internal ALB
resource "aws_lb" "internal_alb" {
  name               = "internalalb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.backend_sg_id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "internal-alb"
  }
}

resource "aws_lb_target_group" "backend_api_tg" {
  name     = "backend-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "backend_gateway_tg" {
  name     = "backend-gateway-tg"
  port     = 5001
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/socket.io/?EIO=4&transport=polling"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "backend_api_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_api_tg.arn
  }
}

resource "aws_lb_listener" "backend_gateway_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 5001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_gateway_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_api_attachment" {
  count            = length(var.backend_instance_ids)
  target_group_arn = aws_lb_target_group.backend_api_tg.arn
  target_id        = var.backend_instance_ids[count.index]
  port             = 5000
}

resource "aws_lb_target_group_attachment" "backend_gateway_attachment" {
  count            = length(var.backend_instance_ids)
  target_group_arn = aws_lb_target_group.backend_gateway_tg.arn
  target_id        = var.backend_instance_ids[count.index]
  port             = 5001
}
