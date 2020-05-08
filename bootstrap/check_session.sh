#!/bin/bash

function get_tenant_sub_details {

    read -p "Enter the tenant name (tenantname.onmicrosoft.com) or guid: " tenant
    read -p "Enter the subscription ID where the launchpad will be deployed: " subscriptionId
        
}

function get_login {

    logged_user_upn=$(az ad signed-in-user show --query userPrincipalName -o tsv)
    echo ""
    echo " - existing Azure user session: ${logged_user_upn}"
    echo ""

    while true; do
        read -p "Do you you want to execute the command with that current user? (y/n): " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) get_login_details; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done

}

function get_login_details {

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
    
    echo ""
    echo "Checking existing Azure session"

    user_type=$(az account show --query user.type -o tsv 2>/dev/null || true)
    if [ "${user_type}" == "servicePrincipal" ]; then
        az logout 2>/dev/null
    fi

    session=$(az account show -o json 2>/dev/null || true)

    if [ "$session" == '' ]; then
        get_tenant_sub_details
        get_login_details
    else
        export tenant=$(az account show -o json | jq -r .tenantId) && echo " detected tenant: ${tenant}"
        export subscriptionId=$(az account show -o json | jq -r .id) && echo " detected subscription: ${subscriptionId}"
        echo ""
        
        while true; do
            read -p "Do you you want to ${tf_command} in this tenant and subscription? (y/n): " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) az logout 2>/dev/null && get_tenant_sub_details; break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
        
        get_login

    fi


    export tenant=${tenant}
    export subscriptionId=${subscriptionId}

}

function set_env_variable {
    variable_name=$1
    read -p "Set the value for ${variable_name}: " var_result
    declare -g ${variable_name}="${var_result}"
    echo "variable ${variable_name} set"
}

function check_variable {
    variable_name=$1
    
    if [ -z ${!variable_name} ]; then
       set_env_variable ${variable_name}
    else
        while true; do
            read -p "The variable ${variable_name} is already set. Do you want to set it again? (y/n): " yn
            case $yn in
                [Yy]* ) unset ${variable_name}; set_env_variable ${variable_name}; break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

}