#----------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootstrap
#
# Made by Denis Astahov
#----------------------------------------------------------


provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-03a71cec707bfc3d7"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Denis",
    l_name = "Astahov",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Denis Astahov"
  }
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"

}
