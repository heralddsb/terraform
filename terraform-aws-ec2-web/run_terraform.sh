#!/bin/bash

# Define the base name for your state files
STATE_FILE_BASE="terraform_state"

# Generate a timestamp
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Define the new state file name with the timestamp
NEW_STATE_FILE="${STATE_FILE_BASE}_${TIMESTAMP}.tfstate"

# Initialize Terraform (if needed)
terraform init

# Run Terraform Apply with the new state file name
terraform apply -state="${NEW_STATE_FILE}"

# Check if Terraform apply was successful
if [ $? -eq 0 ]; then
    echo "Terraform apply completed. State file saved as ${NEW_STATE_FILE}"
else
    echo "Terraform apply failed. No new state file created."
fi