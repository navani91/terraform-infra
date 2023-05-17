data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}


resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = var.component
  }
provisioner "remote_exec" {

connection {
 host     = self.public_ip
 user     = Centos
 password = DevOps321
}

 inline = [
  "git clone https://github.com/navani91/roboshop-shell.git"
  "cd roboshop_shell"
  "sudo bash ${var.component}.sh"
 ]

}

resource "aws_security_group" "sg" {
  name        = "${var.component}-${var.env}-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = ""${var.component}-${var.env}-sg""
  }
resource "aws_route53_record" "record" {
  zone_id = "Z103214126L48SQW30RSR"
  name    = "${var.component}-dev.devopsb71.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.ec2.private_ip]
}


variable "component" {}
variable "instance_type" {}
variable "env" {
  default = "dev"
}