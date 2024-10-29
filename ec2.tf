resource "aws_instance" "default_instance" {
  ami                    = "ami-0d03c6e00d5732e28"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default_sg.id]
  iam_instance_profile   = "EC2access"

  tags = {
    Name = "default-instance"
  }
}

resource "aws_instance" "project_instance" {
  ami                    = "ami-0d03c6e00d5732e28"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.project.id
  vpc_security_group_ids = [aws_security_group.project_sg.id]
  iam_instance_profile   = "EC2access"

  tags = {
    Name = "project-instance"
  }
}
