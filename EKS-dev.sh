#!/bin/bash

# you need to have the AWS CLI configured with a profile that has permission to assume the EKS Admin role.
# You can set this up using:
# aws configure --profile developer-name
# --- Configuration ---
AWS_BASE_PROFILE="developer-name" # The AWS CLI profile that has permission to assume the developer role
EKS_DEVELOPER_ROLE_ARN="arn:aws:iam::911167885172:role/core-serve-eks-cluster-eks-developer-role" # Your EKS Developer Role ARN
EKS_CLUSTER_NAME="core-serve-eks-cluster" # Your EKS Cluster Name
AWS_REGION="eu-west-2" # Your AWS Region
ROLE_SESSION_NAME="EKSDeveloperSession" # A name for your assumed role session
CREDENTIAL_DURATION_SECONDS=3600 # How long temporary credentials are valid (default 1 hour)

# --- Pre-checks ---
echo "--- EKS Developer Access Script ---"
echo "Checking prerequisites..."

command -v jq >/dev/null 2>&1 || { echo >&2 "Error: 'jq' is not installed. Please install it (e.g., sudo apt install jq)."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo >&2 "Error: 'aws cli' is not installed. Please install it."; exit 1; }
command -v kubectl >/dev/null 2>&2 || { echo >&2 "Error: 'kubectl' is not installed. Please install it."; exit 1; }

echo "Prerequisites checked. Attempting to assume role..."

# --- Clear any previous temporary AWS credentials ---
# This is crucial to ensure kubectl picks up the *new* assumed role credentials.
echo "Clearing any lingering temporary AWS credentials from environment..."
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

# --- Assume Role ---
ASSUME_ROLE_OUTPUT=$(aws sts assume-role \
  --profile "$AWS_BASE_PROFILE" \
  --role-arn "$EKS_DEVELOPER_ROLE_ARN" \
  --role-session-name "$ROLE_SESSION_NAME" \
  --duration-seconds "$CREDENTIAL_DURATION_SECONDS" 2>&1)

if [ $? -ne 0 ]; then
  echo "Error: Failed to assume role."
  echo "Please check:"
  echo "  - Your base profile ('$AWS_BASE_PROFILE') is correctly configured and has 'sts:AssumeRole' permissions on '$EKS_DEVELOPER_ROLE_ARN'."
  echo "  - The role ARN '$EKS_DEVELOPER_ROLE_ARN' is correct."
  echo "AWS CLI Output: $ASSUME_ROLE_OUTPUT"
  exit 1
fi

# Extract and export credentials
echo "Extracting temporary credentials..."
export AWS_ACCESS_KEY_ID=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SessionToken')
EXPIRATION=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.Expiration')

echo "Role assumed successfully."
echo "Temporary credentials will expire at: $EXPIRATION (UTC)"
echo "Current AWS identity:"
aws sts get-caller-identity || echo "Could not verify identity. Continue with caution."

# --- Update Kubeconfig ---
echo "Updating kubeconfig for EKS cluster: $EKS_CLUSTER_NAME in $AWS_REGION..."

# Use current environment variables for kubeconfig update.
# Do NOT use --profile here, as that would make kubectl use the base profile's credentials
# instead of the just-assumed role's temporary credentials.
aws eks update-kubeconfig \
  --region "$AWS_REGION" \
  --name "$EKS_CLUSTER_NAME"

if [ $? -ne 0 ]; then
  echo "Error: Failed to update kubeconfig."
  echo "Please ensure 'aws-iam-authenticator' is correctly installed and your IAM role has EKS permissions."
  exit 1
fi

echo "--- Setup Complete! ---"
echo "You are now logged in as the EKS Developer. You can use 'kubectl' commands within your permitted namespaces."
echo "Example: kubectl get pods -n <your-dev-namespace>"
echo ""
echo "IMPORTANT: These temporary credentials will expire. Rerun this script to refresh them."
echo "To revert to your base AWS profile (and clear temporary credentials), run:"
echo "  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN"
echo ""