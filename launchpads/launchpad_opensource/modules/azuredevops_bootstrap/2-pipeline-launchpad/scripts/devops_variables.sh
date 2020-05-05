#!/bin/bash

export AZURE_DEVOPS_EXT_PAT=${PAT_TOKEN}

az devops configure -d organization="${organization}" project="${project}"

id=$(az pipelines variable-group create \
    --name "release-level0-boostrap" \
    --variables "TF_VAR_pipeline_level"="level0" \
    --org ${organization} --project "${project}" | jq -r .id)

# Variable must be set as export AZURE_DEVOPS_EXT_PIPELINE_VAR_ARM_CLIENT_ID=''
az pipelines variable-group variable create \
    --group-id ${id} \
    --name "ARM_CLIENT_ID" \
    --value ${ARM_CLIENT_ID} 

az pipelines variable-group variable create \
    --group-id ${id} \
    --name "ARM_CLIENT_SECRET" \
    --value ${ARM_CLIENT_SECRET} \
    --secret true 

az pipelines variable-group variable create \
    --group-id ${id} \
    --name "ARM_SUBSCRIPTION_ID" \
    --value ${ARM_SUBSCRIPTION_ID} 

az pipelines variable-group variable create \
    --group-id ${id} \
    --name "ARM_TENANT_ID" \
    --value ${ARM_TENANT_ID}
