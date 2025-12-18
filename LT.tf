resource "aws_iam_role" "ec2_s3_role" {
  name = "wp-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy" "s3_policy" {
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:*"]
      Resource = [
        "arn:aws:s3:::wp-media-prod-bucket",
        "arn:aws:s3:::wp-media-prod-bucket/*"
      ]
    }]
  })
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "wp-ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}
resource "aws_launch_template" "lt" {
  name_prefix   = "wp-lt"
  image_id      = "ami-00ca570c1b6d79f36"
  instance_type = "t3.micro"
  key_name      = "project"

  user_data = filebase64("userdata.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }
}

