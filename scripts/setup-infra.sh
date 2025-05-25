#!/bin/bash

# Exit immediately if a command fails
set -e

# Set AWS Region
AWS_REGION="us-west-2"

# 1. Create VPC
echo "🔧 Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --region "$AWS_REGION" \
  --query 'Vpc.VpcId' \
  --output text)
echo "✅ Created VPC: $VPC_ID"

# 2. Enable DNS support & hostnames
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames "{\"Value\":true}"
echo "✅ Enabled DNS support and hostnames"

# 3. Create Public Subnet
echo "🔧 Creating public subnet..."
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block 10.0.0.0/24 \
  --availability-zone "${AWS_REGION}a" \
  --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' \
  --output text)
echo "✅ Created public subnet: $PUBLIC_SUBNET_ID"

# 4. Create Internet Gateway
echo "🔧 Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --region "$AWS_REGION" \
  --query 'InternetGateway.InternetGatewayId' \
  --output text)
echo "✅ Created Internet Gateway: $IGW_ID"

# 5. Attach IGW to the VPC
aws ec2 attach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID"
echo "✅ Attached IGW to VPC"

# 6. Create Route Table
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" \
  --region "$AWS_REGION" \
  --query 'RouteTable.RouteTableId' \
  --output text)
echo "✅ Created Route Table: $ROUTE_TABLE_ID"

# 7. Create route to Internet
aws ec2 create-route \
  --route-table-id "$ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"
echo "✅ Added route to internet"

# 8. Associate route table with public subnet
aws ec2 associate-route-table --route-table-id "$ROUTE_TABLE_ID" --subnet-id "$PUBLIC_SUBNET_ID"
echo "✅ Associated route table with public subnet"

# 9. Tag all resources
aws ec2 create-tags \
  --resources "$VPC_ID" "$PUBLIC_SUBNET_ID" "$IGW_ID" "$ROUTE_TABLE_ID" \
  --tags Key=Project,Value=aws-cli-infra-setup
echo "🏷️  Tagged resources"

# 10. Create Private Subnet
echo "🔧 Creating private subnet..."
PRIV_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" \
  --cidr-block 10.0.2.0/24 \
  --availability-zone "${AWS_REGION}a" \
  --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' \
  --output text)
echo "✅ Created Private Subnet: $PRIV_SUBNET_ID"

# 11. Save to env file
echo "VPC_ID=$VPC_ID" > vpc-ids.env
echo "PUB_SUBNET_ID=$PUBLIC_SUBNET_ID" >> vpc-ids.env
echo "PRIV_SUBNET_ID=$PRIV_SUBNET_ID" >> vpc-ids.env

# 🎉 Completion Message
echo ""
echo "🎉 Infrastructure setup complete!"
echo "VPC_ID=$VPC_ID"
echo "PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID"
echo "PRIVATE_SUBNET_ID=$PRIV_SUBNET_ID"
echo "INTERNET_GATEWAY_ID=$IGW_ID"
echo "ROUTE_TABLE_ID=$ROUTE_TABLE_ID"





