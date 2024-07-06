locals {
  name_prefix = "${var.customer}-${var.product}-${var.environment}-${var.instance_name}"
}

resource "aws_security_group" "instance_sg" {
  name        = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  description = "Security group for EC2 instances"

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg"
  }
}

resource "aws_instance" "ec2_instance" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "${local.name_prefix}-${count.index}"
  }

  dynamic "ebs_block_device" {
    for_each = var.data_ebs_volume ? [1] : []
    content {
      device_name = "/dev/sdh"
      volume_size = var.data_volume_size
    }
  }
}

resource "aws_ebs_volume" "data_volume" {
  count             = var.data_ebs_volume ? var.instance_count : 0
  availability_zone = element(var.subnet_ids, count.index % length(var.subnet_ids))
  size              = var.data_volume_size

  tags = {
    Name = "${local.name_prefix}-${count.index}-data"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count        = var.data_ebs_volume ? var.instance_count : 0
  device_name  = "/dev/sdh"
  volume_id    = element(aws_ebs_volume.data_volume[*].id, count.index)
  instance_id  = element(aws_instance.ec2_instance[*].id, count.index)
  depends_on   = [aws_instance.ec2_instance]
}

resource "aws_eip" "elastic_ip" {
  count      = var.elastic_ip_attachment ? var.instance_count : 0
  depends_on = [aws_instance.ec2_instance]
}

resource "aws_eip_association" "eip_association" {
  count          = var.elastic_ip_attachment ? var.instance_count : 0
  instance_id    = element(aws_instance.ec2_instance[*].id, count.index)
  allocation_id  = element(aws_eip.elastic_ip[*].id, count.index)
  depends_on     = [aws_instance.ec2_instance]
}