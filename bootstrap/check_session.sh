#!/bin/bash

function get_login_details {

    if [ "${1}" == "true" ]; then
        read -p "Enter the tenant name (tenantname.onimcrosoft.com) or guid: " tenant
        read -p "Enter the subscription ID where the launchpad will be deployed: " subscriptionId
    fi 

    if [ "${tenant}" != '' ]; then
        echo " - login to tenant ${tenant}"
        az login --tenant ${tenant}
    else
        az login
    fi

    if [ "${subscriptionId}" != '' ]; then
        az account set -s ${subscriptionId}
    fi

    unset ARM_CLIENT_ID
    unset ARM_CLIENT_SECRET
    unset ARM_SUBSCRIPTION_ID
    unset ARM_TENANT_ID

}

function check_session {
    
    echo "Checking existing Azure session"
    session=$(az account show -o json 2>/dev/null || true)


    if [ "$session" == '' ]; then
        get_login_details
    else
        echo ""
        export tenant=$(az account show -o json | jq -r .tenantId) && echo " detected tenant: ${tenant}"
        export subscriptionId=$(az account show -o json | jq -r .id) && echo " detected subscription: ${subscriptionId}"
        echo ""
        
        while true; do
            read -p "Do you you want to ${tf_command} in this tenant and subscription? (y/n): " yn
            case $yn in
                [Yy]* ) get_login_details false; break;;
                [Nn]* ) az logout 2>/dev/null && get_login_details true; break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi


    export tenant=${tenant}
    export subscriptionId=${subscriptionId}

}