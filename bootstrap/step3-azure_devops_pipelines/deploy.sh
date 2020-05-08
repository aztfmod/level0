#!/bin/bash

set -e

pwd
source ./check_session.sh



# check_variable TF_VAR_azure_devops_organization_url
# check_variable TF_VAR_pat_full_access_scope
# check_variable TF_VAR_pat_agent_pools_manage_scope


cd ./step1-create_bootstrap_account/
terraform init
export TF_VAR_bootstrap_ARM_CLIENT_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_ID.value)
export TF_VAR_bootstrap_ARM_CLIENT_SECRET=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_SECRET.value)
export TF_VAR_bootstrap_ARM_SUBSCRIPTION_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_SUBSCRIPTION_ID.value)
export TF_VAR_bootstrap_ARM_TENANT_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_TENANT_ID.value)


cd ../step3-azure_devops_pipelines/

terraform init
terraform $@

