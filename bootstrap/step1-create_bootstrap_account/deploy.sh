#!/bin/bash

pwd
source ./check_session.sh
cd ./step1-create_bootstrap_account/

echo ""
echo "Login with a Global Administrator account user:"
echo ""

check_session


echo "Starting ${tf_command} in"
echo " - tenant:          ${tenant}"
echo " - subscription ID: ${subscriptionId}"
echo ""

mkdir -p ${TF_DATA_DIR}/tfstates/step1

terraform init
terraform $@ -state=${TF_DATA_DIR}/tfstates/step1/terraform.tfstate
