#!/bin/bash

set -e

pwd
source ./check_session.sh
cd ./step2-create_subscription_custom_role/

check_session

mkdir -p ${TF_DATA_DIR}/tfstates/step2

terraform init
terraform $@ -state=${TF_DATA_DIR}/step2/terraform.tfstate
