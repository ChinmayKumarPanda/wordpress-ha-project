resource "aws_instance" "bastion" {
  ami                         = "ami-00ca570c1b6d79f36"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id   # public subnet
  key_name                    = "project"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }
}
