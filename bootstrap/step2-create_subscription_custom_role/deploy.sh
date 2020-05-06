set -e

pwd
cd ./step2-create_subscription_custom_role/

unset ARM_CLIENT_ID
unset ARM_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID
unset ARM_TENANT_ID

az logout 2>/dev/null

echo ""
echo "Login (with a user) with an Azure Subscription Owner to manage the CAF-bootstrap custom role:"
echo ""

if [ "${tenant}" != '' ]; then
    echo " - login to tenant ${tenant}"
    az login --tenant ${tenant}
else
    az login
fi

if [ "${subscriptionId}" != '' ]; then
    az account set -s ${subscriptionId}
fi

terraform init
terraform $@

