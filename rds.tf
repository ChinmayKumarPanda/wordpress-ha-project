resource "aws_security_group" "rds_sg" {
  name   = "wp-rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp-rds-sg"
  }
}
resource "aws_db_subnet_group" "wp_db_subnet" {
  name = "wp-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "wp-db-subnet-group"
  }
}
resource "aws_db_instance" "wp_db" {
  identifier = "wp-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"
  allocated_storage = 20

  db_name  = "wordpress"
  username = "admin"
  password = "StrongPassword123!"   # 🔴 change this

  multi_az = false                  # true for production
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wp_db_subnet.name

  skip_final_snapshot = true

  tags = {
    Name = "wp-rds-mysql"
  }
}
