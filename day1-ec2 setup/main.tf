# Configure the AWS provider
provider "aws" {
  region = "eu-north-1"
}

# Create a key pair for SSH access to EC2 instances
resource "aws_key_pair" "deployer" {
  key_name   = "linux_deployer_key"
  public_key = file("C:/Users/maneesha yasinth/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "day1_sg" {
  name        = "day1_security_group"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "day1_ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.day1_sg.id]

    tags = {
        Name = "linux-learner-EC2-Instance"
    }
}