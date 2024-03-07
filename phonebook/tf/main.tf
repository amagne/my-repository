resource "aws_alb" "app-lb" {
  name               = "phonebook-lb-tf"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = data.aws_subnets.pb-subnets.ids
}

resource "aws_alb_listener" "app-listener" {
  load_balancer_arn = aws_alb.app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-lb-tg.arn
  }
}

resource "aws_alb_target_group" "app-lb-tg" {
  name     = "phonebook-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_autoscaling_group" "app-asg" {
  name                      = "phonebook-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.app-lb-tg.arn]
  vpc_zone_identifier       = aws_alb.app-lb.subnets # [for subnet in aws_subnets.pb-subnets : subnet.id]
  launch_template {
    id      = aws_launch_template.asg-lt.id
    version = aws_launch_template.asg-lt.latest_version
  }
}

resource "aws_launch_template" "asg-lt" {
  name                   = "phonebook-lt"
  image_id               = data.aws_ami.al2023.id
  instance_type          = "t2.micro"
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.server-sg.id]

  user_data = base64encode(templatefile("user-data.sh", { db-endpoint = aws_db_instance.db-server.address, user-data-git-token = var.git-token, user-data-git-name = var.git-name, user-data-git-repo = var.git-repo }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web Server of Phonebook App"
    }
  }
}

resource "aws_db_instance" "db-server" {
  identifier                  = "phonebook-app-db"
  instance_class              = "db.t2.micro"
  allocated_storage           = 20
  vpc_security_group_ids      = [aws_security_group.db-sg.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
  db_name                     = "phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  username                    = "admin"

  # For simplicity, db password is hardcoded here. 
  # In a production level project, mechanisms must be setup to protect sensitive data
  password                    = "Pass_1234"
  
  monitoring_interval         = 0
  multi_az                    = false
  port                        = 3306
  publicly_accessible         = false
  skip_final_snapshot         = true
}

resource "github_repository_file" "dbendpoint" {
  content             = aws_db_instance.db-server.address
  file                = "dbserver.endpoint"
  repository          = var.git-repo
  overwrite_on_create = true
  branch              = "main"
}

resource "aws_route53_record" "phonebook" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "phonebook.${var.hosted-zone}"
  type    = "A"
  alias {
    name                   = aws_alb.app-lb.dns_name
    zone_id                = aws_alb.app-lb.zone_id
    evaluate_target_health = true
  }
}