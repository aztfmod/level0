#!/bin/bash

set -e

pwd
source ./check_session.sh



cd ./step1-create_bootstrap_account/
terraform init
export TF_VAR_bootstrap_ARM_CLIENT_ID=$(terraform show -json ${TF_DATA_DIR}/tfstates/step1/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_ID.value)
export TF_VAR_bootstrap_ARM_CLIENT_SECRET=$(terraform show -json ${TF_DATA_DIR}/tfstates/step1/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_SECRET.value)
export TF_VAR_bootstrap_ARM_SUBSCRIPTION_ID=$(terraform show -json ${TF_DATA_DIR}/tfstates/step1/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_SUBSCRIPTION_ID.value)
export TF_VAR_bootstrap_ARM_TENANT_ID=$(terraform show -json ${TF_DATA_DIR}/tfstates/step1/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_TENANT_ID.value)


cd ../step3-azure_devops_pipelines/

mkdir -p ${TF_DATA_DIR}/tfstates/step3

terraform init
terraform $@ -state=${TF_DATA_DIR}/tfstates/step3/terraform.tfstate
