###################################
# ALB
###################################
resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "application"
  security_groups    = var.sg_ids
  subnets            = var.subnet_ids

  tags = {
    Name = var.name
  }
}

###################################
# Target Group
###################################
resource "aws_lb_target_group" "this" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

###################################
# Attach EC2 instances
###################################
resource "aws_lb_target_group_attachment" "a" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "b" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_ids[1]
  port             = 80
}

###################################
# Listener
###################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}