#----------------------------------------------------------
#
# Build WebServer during Bootstrap
# Made by Maksym Tsybulskyi
# tomahawksmail@gmail.com
#
#----------------------------------------------------------
/*
Past script to user-data to install NGINX if CentOS
#!/bin/bash
yum install epel-release -y
yum install nginx -y
export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
echo Droplet: $HOSTNAME, IP Address: $PUBLIC_IPV4 > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx
*/

provider "aws" {
  region = var.region
}


resource "aws_instance" "simple_webserver" {
  ami                    = var.ami_iso
  instance_type          = var.instance_type
  # attach aws_instance to SecurityGroup
  vpc_security_group_ids = [aws_security_group.security_group_for_webserver.id]
  # Bootstraping (Apache to CentOS)
  user_data              = file("script.sh")
#  user_data              = <<EOF
#script past here without spaces
#EOF

  tags = {
    Name  = "simple_webserver"
    Owner = "Maksym Tsybulskyi"
  }
}


resource "aws_security_group" "security_group_for_webserver" {
  name = "WebServer Security Group"
  description = "My Security Group"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "simple_webserver"
    Owner = "Maksym Tsybulskyi"
  }
}

output "instance_public_ip" {
  value = aws_instance.simple_webserver.public_ip
}
