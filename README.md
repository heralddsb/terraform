# Simple AWS Infrastructure with EC2 Instance Web Server Template

This Terraform Infrastructure as Code (IaC) configuration sets up a basic AWS infrastructure suitable for hosting a web server on an EC2 instance. The template automates the creation of networking components and a web server, illustrating a practical use of cloud resources to deploy a scalable and secure application environment.

## Overview

The configuration provisions the following resources:

- **Virtual Private Cloud (VPC)**: A custom AWS VPC to isolate and manage cloud resources securely.
- **Internet Gateway**: An Internet Gateway to enable communication between the VPC and the internet.
- **Egress-Only Internet Gateway**: An IPv6 specific gateway for outbound internet access without allowing inbound traffic.
- **Route Table**: A route table with routes for directing both IPv4 and IPv6 traffic out through the respective gateways.
- **Subnet**: A subnet within the VPC for deploying AWS resources like EC2 instances.
- **Route Table Association**: Links the subnet to the route table to ensure proper routing of traffic.
- **Security Group**: A security group to allow inbound traffic on HTTP (80), HTTPS (443), and SSH (22) ports, and allow all outbound traffic.
- **Network Interface**: A network interface with a static private IP within the subnet, attached to the security group.
- **Elastic IP**: A static public IP associated with the network interface to reliably access the EC2 instance from the internet.
- **EC2 Instance**: Deploys an EC2 instance using a specified AMI and instance type, equipped with a startup script to install and start an Apache web server displaying a simple message.

## Prerequisites

Before deploying this template, you will need:
- Terraform installed on your machine.
- An AWS account with the necessary permissions to create the resources.
- AWS CLI installed and configured with your credentials.

Confirm the destruction when prompted to avoid accidental deletions.

## Note

This template is designed for educational purposes and may require modifications to meet production-grade security and reliability standards.


To use this Terraform template:

1. Clone the repository containing this Terraform configuration.
2. Navigate to the directory containing this README.
3. Initialize the Terraform environment with the command:
