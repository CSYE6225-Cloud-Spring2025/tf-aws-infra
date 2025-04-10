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

## Assignment 8
1. Create `openssl-san.cnf` with the domain name to be verified and other details
2. Create CSR using `openssl req -new -newkey rsa:2048 -nodes -keyout demo.sarthakmallick.me.key -out demo.sarthakmallick.me.csr -config openssl-san.cnf`
3. Use the `demo.sarthakmallick.me.csr` generated above to buy SSL Certificate
4. Validate the certificate by adding verification CNAME entry in subdomain hosted zone
5. Import the certificates into current folder and run `aws acm import-certificate --certificate fileb://demo_sarthakmallick_me.crt --private-key fileb://demo.sarthakmallick.me.key --certificate-chain fileb://demo_sarthakmallick_me.ca-bundle --profile demo --region us-east-1`
6. Assign the generated ARN value to `ssl_certificate_arn` in `demo.tfvars`