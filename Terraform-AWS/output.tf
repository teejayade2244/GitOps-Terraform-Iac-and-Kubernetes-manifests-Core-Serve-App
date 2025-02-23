output "vpc_id" {
  description = "The ID of the VPC created"
  value       = module.VPC.vpc_id
}

output "main_security_group_id" {
  value       = module.main_security_group.security_group_id
  description = "The ID of the main security group"
}

output "EC2_security_group_id" {
  value       = module.EC2_security_group_app.security_group_id
  description = "The ID of the EC2 security group"
}

output "Blackrose_security_group_id" {
  value       = module.Blackrose_security_group_app.security_group_id
  description = "The ID of the Blackrose security group"
}


# STEP3: GET EC2 USER NAME AND PUBLIC IP 
output "SERVER-SSH-ACCESS" {
  value = "ubuntu@${module.main_server.public_ip}"
}

# STEP4: GET EC2 PUBLIC IP 
output "PUBLIC-IP" {
  value = "${module.main_server.public_ip}"
}

# STEP5: GET EC2 PRIVATE IP 
output "PRIVATE-IP" {
  value = "${module.main_server.public_ip.private_ip}"
}