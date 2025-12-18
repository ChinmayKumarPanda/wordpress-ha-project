resource "aws_launch_template" "lt" {
  name_prefix   = "wp-lt"
  image_id      = "ami-00ca570c1b6d79f36"
  instance_type = "t3.micro"
  key_name      = "project"

  user_data = filebase64("userdata.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }
}
