## Assignment 3
1. Run `terraform init` to download the aws modules
2. Create a <env>.tfvars file to configure the variables
3. Run `terraform plan -var-file=<env>.tfvars` to view the plan
4. Run `terraform apply -var-file=<env>.tfvars` to create the resources
5. Run `terraform destroy -var-file=<env>.tfvars` to tear down all resources

## Assignment 4
1. For `AWS` copy the <ami_id> of the created AMI and add it in <env>.tfvars file
2. Run terraform init, plan and apply commands as above to create the vpc and the ec2 instance
3. Get the public ipv4 address from AWS console and adjust the endpoint to send requests