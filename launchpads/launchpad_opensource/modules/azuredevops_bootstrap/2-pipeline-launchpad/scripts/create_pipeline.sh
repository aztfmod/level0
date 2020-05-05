#!/bin/bash

path=${environment}\\${level}

export AZURE_DEVOPS_EXT_PAT=${PAT_TOKEN}
az devops configure -d organization="${organization}" project="${project}"


az pipelines folder create --path ${path} --org ${organization} --project "${project}" 2>/dev/null


az pipelines create --name "${level}_release_agent" \
    --description "${level} release agent in charge of the landing zones" \
    --folder-path "${path}" \
    --repository "caf-configuration" \
    --repository-type "tfsgit" \
    --branch "master" \
    --yml-path ${yml_path} \
    --org ${organization} --project "${project}" 
