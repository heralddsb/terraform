#Terraform - Auto Create AWS Instance and run webserver

##Main Commands

- **terrraform init** - For initialization, download the resources needed

- **terrraform plan** - Preview the changes before applying or creating the intrastructure in AWS.

- **terraform apply** - Run the script. It will create or update the existing infrastructure

- **terraform apply --auto-approve** - Runs the script without typing “yes”. This will skip the approval

- **terraform apply -state=tfstate_datetime.tfstate** - Runs the script and generates the state file named tfstate_datetime.tfstate

- **terraform destroy -state=tfstate_datetime.tfstate** - Destroy the created resources by terraform.

##Visual Commands

- **terrraform graph** - For initialization, download the resources needed

- **terrraform plan -out=plan.out** - Generate the a binary

###Resource

- [Terraform Main Commands](https://developer.hashicorp.com/terraform/cli/commands)

- [Terraform Environment Variable](https://developer.hashicorp.com/terraform/cli/config/environment-variables)
