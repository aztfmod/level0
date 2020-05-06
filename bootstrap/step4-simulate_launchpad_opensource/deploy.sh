
pwd
cd ./step4-simulate_launchpad_opensource/
pwd

terraform init

export ARM_CLIENT_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_ID.value)
export ARM_CLIENT_SECRET=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_CLIENT_SECRET.value)
export ARM_SUBSCRIPTION_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_SUBSCRIPTION_ID.value)
export ARM_TENANT_ID=$(terraform show -json ../step1-create_bootstrap_account/terraform.tfstate | jq -r .values.outputs.bootstrap_ARM_TENANT_ID.value)


if [ "${ARM_CLIENT_ID}" != "null" ]; then
    az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

    clientId=$(az account show --query user.name -o tsv)
    TF_VAR_logged_user_objectId=$(az ad sp show --id ${clientId} --query objectId -o tsv)
    echo " - logged in Azure AD application:  ${TF_VAR_logged_user_objectId} ($(az ad sp show --id ${clientId} --query displayName -o tsv))"

    
    terraform $@
else
    echo "No step1 tfstate file"
fi