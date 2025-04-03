# Fetch .tfvars from SSM and save to a temporary file
aws ssm get-parameter --name "/core-serve/dev/terraform.tfvars" --with-decryption --query Parameter.Value --output text > dev.tfvars