pwd
cd ./step1-create_bootstrap_account/

unset ARM_CLIENT_ID
unset ARM_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID
unset ARM_TENANT_ID

az logout 2>/dev/null

echo ""
echo "Login with a Global Account user:"
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

