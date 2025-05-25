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

