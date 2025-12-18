output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "rds_endpoint" {
  description = "RDS MySQL endpoint for WordPress"
  value       = aws_db_instance.wp_db.address
}
