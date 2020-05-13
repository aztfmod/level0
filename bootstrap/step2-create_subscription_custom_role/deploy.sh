#!/bin/bash

set -e

cd ./step1-create_bootstrap_account/
terraform init
export TF_VAR_prefix=$(terraform show -json ${TF_DATA_DIR}/tfstates/step1/terraform.tfstate | jq -r .values.outputs.prefix.value)

cd ..

pwd
source ./check_session.sh
cd ./step2-create_subscription_custom_role/

check_session

mkdir -p ${TF_DATA_DIR}/tfstates/step2

terraform init
terraform $@ -state=${TF_DATA_DIR}/tfstates/step2/terraform.tfstate -var step1_tfstate_path=${TF_DATA_DIR}/tfstates/step1
