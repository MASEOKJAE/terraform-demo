provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  vpc_security_group_ids      = [aws_security_group.instance.id]
  ami                         = "ami-024ea438ab0376a47"
  instance_type               = "t2.micro"
  user_data                   = <<-EOF
                                #!/bin/bash
                                echo "hello world" > index.html
                                nohup busybox httpd -f -p ${var.server_port} &
  EOF
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
 description = "The port. the server will use for HTTP requests"
 type = number
 default = 8888
}
output "public_ip" {
 value = aws_instance.example.public_ip
 description = "The public IP address of the web server"
}
