# ==============================================================================
# modules/vpc-security/ec2.tf
# Bastion, app, and data simulation instances
# ==============================================================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  monitoring                  = true

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-bastion"
    Role = "bastion"
  })
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app_a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_pair_name
  monitoring             = true

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-app"
    Role = "app"
  })
}

resource "aws_instance" "data" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.data_a.id
  vpc_security_group_ids = [aws_security_group.data.id]
  key_name               = var.key_pair_name
  monitoring             = true

  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
    #!/bin/bash
    python3 -c "
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('0.0.0.0', 5432))
    s.listen(5)
    while True:
        conn, addr = s.accept()
        conn.send(b'DB simulation running\n')
        conn.close()
    " &
  EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-data"
    Role = "data"
  })
}