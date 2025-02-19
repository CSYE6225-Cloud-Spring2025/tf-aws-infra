# Assignment 3
1. Run `terraform init` to download the aws modules
2. Create a <env>.tfvars file to configure the variables
3. Run `terraform plan -var-file=<env>.tfvars` to view the plan
4. Run `terraform apply -var-file=<env>.tfvars` to create the resources
5. Run `terraform destroy -var-file=<env>.tfvars` to tear down all resources
6. Testing PR checks