# terraform-course
Creating resources in AWS using Terraform

# For creating the S3 resource
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-east-1"
terraform plan -out=tfplan -var project_name=la-terraform
terraform apply tfplan
terraform destroy -auto-approve -var project_name=la-terraform

The file `terraform.tfvars` are for setting default variables

