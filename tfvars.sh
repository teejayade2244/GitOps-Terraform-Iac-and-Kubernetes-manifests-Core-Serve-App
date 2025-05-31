#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Install it first: https://aws.amazon.com/cli/"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS credentials not configured. Run 'aws configure' or set ENV variables."
    exit 1
fi

# Fetch .tfvars from SSM
aws ssm get-parameter \
    --name "/core-serve/dev/dev.tfvars" \
    --with-decryption \
    --query Parameter.Value \
    --output text \
    > "dev.tfvars"

if [ $? -eq 0 ]; then
    echo "Successfully fetched dev.tfvars from SSM."
else
    echo "Failed to fetch dev.tfvars. Check permissions/parameter name."
    exit 1
fi


