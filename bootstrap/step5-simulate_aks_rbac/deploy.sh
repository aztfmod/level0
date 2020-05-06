set -e

pwd
cd ./step5-simulate_aks_rbac/

terraform init

export ARM_CLIENT_ID=$(terraform show -json ../step4-simulate_launchpad_opensource/terraform.tfstate | jq -r .values.outputs.launchpad_ARM_CLIENT_ID.value)
export ARM_CLIENT_SECRET=$(terraform show -json ../step4-simulate_launchpad_opensource/terraform.tfstate | jq -r .values.outputs.launchpad_ARM_CLIENT_SECRET.value)
export ARM_SUBSCRIPTION_ID=$(terraform show -json ../step4-simulate_launchpad_opensource/terraform.tfstate | jq -r .values.outputs.launchpad_ARM_SUBSCRIPTION_ID.value)
export ARM_TENANT_ID=$(terraform show -json ../step4-simulate_launchpad_opensource/terraform.tfstate | jq -r .values.outputs.launchpad_ARM_TENANT_ID.value)

if [ "${ARM_CLIENT_ID}" != "null" ]; then
    az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

    clientId=$(az account show --query user.name -o tsv)
    TF_VAR_logged_user_objectId=$(az ad sp show --id ${clientId} --query objectId -o tsv)
    echo " - logged in Azure AD application:  ${TF_VAR_logged_user_objectId} ($(az ad sp show --id ${clientId} --query displayName -o tsv))"

    terraform $@
else
    echo "No state file in step4"
fi