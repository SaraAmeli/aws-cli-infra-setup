# AWS CLI Infrastructure Setup 🚀

This repository contains a set of Bash scripts that use the AWS CLI to provision a basic VPC infrastructure in AWS, including:

- ✅ VPC with DNS enabled
- 🌐 Public & Private Subnets
- 🌍 Internet Gateway
- 📶 NAT Gateway for Private Subnet
- 🧭 Route Tables
- 🖥️ Public & Private EC2 instances with SSH access and automatic updates

---

## 📦 Prerequisites

- AWS CLI installed & configured
- A valid key pair in your AWS account (`your-key-name`)
- IAM user/role with permissions for EC2, VPC, and networking
- Ubuntu-based AMI ID (like `ami-0abcdef1234567890`) for your region

---

## 📁 Directory Structure

aws-cli-infra-setup/

├── scripts/

│ ├── setup-infra.sh # Main infrastructure script

│ └── userdata.sh # EC2 bootstrap script

├── vpc-ids.env # Auto-generated VPC resource IDs

├── .gitignore

└── README.md


## 🚀 Usage

1. **Clone the repository**
```bash
git clone https://github.com/your-username/aws-cli-infra-setup.git
cd aws-cli-infra-setup

