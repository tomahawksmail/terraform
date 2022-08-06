# Пример создания инфраструктуры в AWS
################################################################################
# Создать S3 для хранения tf.state
# aws s3api create-bucket --bucket <Your_Unique_Name> --region us-east-1

# Создать ключ
#aws ec2 create-key-pair —key-name aws_hillel --query 'KeyMaterial' --output text > aws_hillel.pem

# Проверьте доступ к данному серверу по ssh:
# ssh -i <path_to_your_private_key> ubuntu@<Public_IP_Instance>


# Провайдер
provider "aws" {
  region = "us-west-2"
}
# Вывод после создания
# instance_id
# instance_public_ip
output "instance_id" {
  value = aws_instance.srv[*].id
}
output "instance_public_ip" {
  value = aws_instance.srv[*].public_ip
}

# Instance parameters
variable "instance_type" {
  default = "t2.micro"
}

# Amount of instances
variable "instance_count" {
  default = 2
}

# Tags
variable "tags" {
  type = map(string)

  default = {
    Team    = "developers"
    Project = "name_of_project"
  }
}
# Получение сведений
data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow 80 and 443 inbound traffic"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "tcp_80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
  ingress {
    description = "tcp_443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
  ingress {
    description = "tcp_22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "109.122.24.237/32",
      data.aws_vpc.default.cidr_block
      ]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "web"
  }
}

resource "aws_instance" "srv" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  count                  = var.instance_count
  tags                   = var.tags
  key_name               = "aws_hillel"
  vpc_security_group_ids = [aws_security_group.web.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install wget curl nginx vim -y"
    ]
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(var.private_key_path)
        host = self.public_ip
    }
  }
}

variable "private_key_path" {
  type        = string
  description = "Path to SSH private key"
  default = "./aws_hillel.pem"
}

# aws ec2 create-key-pair --key-name aws_hillel --query 'KeyMaterial' --output text > aws_hillel.pem

resource "aws_elb" "elb" {
  name = "ec2elb"
  availability_zones = aws_instance.srv[*].availability_zone

  dynamic "listener" {
    for_each = ["80","443"]
    content {
      instance_port = listener.value
      instance_protocol = "http"
      lb_port = listener.value
      lb_protocol = "http"
    }
  }

  health_check {
    healthy_threshold =  2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:22"
    interval = 30
  }

  instances                   = aws_instance.srv[*].id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

output "elb_url" {
  value = aws_elb.elb.dns_name
}
