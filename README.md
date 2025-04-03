## Assignment 3
1. Run `terraform init` to download the aws modules
2. Create a <env>.tfvars file to configure the variables
3. Run `terraform plan -var-file=<env>.tfvars` to view the plan
4. Run `terraform apply -var-file=<env>.tfvars` to create the resources
5. Run `terraform destroy -var-file=<env>.tfvars` to tear down all resources

## Assignment 4
1. For `AWS` copy the <ami_id> of the created AMI and add it in <env>.tfvars file
2. Run terraform init, plan and apply commands as above to create the vpc and the ec2 instance
3. Get the public ipv4 address from AWS console to send requests

## Assignment 5
1. Run `ssh -i <aws-ec2-key> ubuntu@<ipv4-addresss>` to ssh into the ec2 instance
2. Install MySQL client using `sudo apt-get install mysql-client`
3. In the ec2 use `sudo su` to view the RDS credentials in `/opt/csye6225/webapp/.env`
4. Connect to the RDS MySQL server by `mysql -h <db-host> -P 3306 -u csye6225 -p`

## Assignment 7
1. Create a hosted zone in the subaccount for the subdomain
2. Copy the Zone ID of the Route 53 hosted zone and add it to `route53_zone_id` in `<env>.tfvars`
3. Use Apache Benchmark to send bulk requests `ab -n 10000 -c 100 http://<domain.tld>/healthz`