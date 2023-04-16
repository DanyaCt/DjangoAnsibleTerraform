# DjangoAnsibleTerraform
## Task

Create infrastructure using Terraform and deploy a test application that requires a database (https://github.com/digitalocean/sample-django) and meets the following infrastructure requirements:

- Create a VPC with public and private networks
- Create three EC2 instances, two in the public network with the application and one in the private network for the database
- Configure a load balancer that will distribute traffic between application instances
- Use Terraform to generate an output file in inventory format for Ansible
- With Ansible, create two roles:
  
  a. Installing infrastructure role: Use a jump host (any of the public instances) to install Postgres on the instance, create a user and a database, install the necessary software on the application instances, and configure Nginx to redirect requests from port 80 to the Django application.
 
  b. Deploying application role: Update the code from Github, update the configs with the current DB credentials, and run DB migrations.

## How to run
### 1 STEP - Download prerequisites

Clone repository to your computer
```
git clone https://github.com/DanyaCt/DjangoAnsibleTerraform
```
Additionally, you need to download Terraform, AWS CLI, and Ansible. You can use the following links:

>Terraform: https://developer.hashicorp.com/terraform/downloads
>
>AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
>
>Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

Next, you must log in to your AWS account. Here's a guide for this:
>https://docs.aws.amazon.com/cli/latest/reference/configure/

### 2 STEP - Create key pair

Note: Your key pair must be in the same region as all your other resources (by default 'eu-central-1'; you can change it in the variables.tf file on line 2).

Create a key pair in AWS using the following guide:

>https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

Then, install your key in the project folder and enter the name of the key in variables.tf on line 6.

And change the permissions for your key:
```
chmod 400 <your key>
```

### 3 STEP - Run Terraform

Run these commands:
```
terraform init
terraform apply --auto-approve
```
Here you create infrastructure in AWS for the Django app.

### 4 STEP - Run Ansible

Enter the 'ansible' folder:
```
cd ansible/
```

And run the command:
```
ansible-playbook -i ../inventory.ini --private-key "../<your key name>.pem" install.yml
```
Here you install dependencies for the Django app and deploy it.

After a few minutes, you can access the site with the DNS name from the Terraform output by pasting it into your browser!

## Destroy your app
Run this command to destroy the Django app:
```
terraform destroy --auto-approve
```

