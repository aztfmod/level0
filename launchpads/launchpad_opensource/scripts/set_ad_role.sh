#!/bin/bash

set -e

ROLE_AAD=$(az rest --method Get --uri https://graph.microsoft.com/v1.0/directoryRoles | jq -r '.value[] | select(.displayName == "'"$(echo ${AD_ROLE_NAME})"'") | .id')
 
URI=$(echo  "https://graph.microsoft.com/v1.0/directoryRoles/${ROLE_AAD}/members/\$ref") && echo " - uri: $URI"

# grant AAD role to the AAD APP
JSON=$( jq -n \
            --arg uri_role "https://graph.microsoft.com/v1.0/directoryObjects/${SERVICE_PRINCIPAL_OBJECT_ID}" \
        '{"@odata.id": $uri_role}' ) && echo " - body: $JSON"

az rest --method POST --uri $URI --header Content-Type=application/json --body "$JSON"

