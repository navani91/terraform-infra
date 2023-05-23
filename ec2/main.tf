data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "devops-practic-with-ansible"
  owners      = [data.aws_caller_identity.current.account_id]
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
  "ansible-pull -i localhost, -u https://github.com/navani91/roboshop-ansible roboshop.yml -e role_name${var.component}"
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