#!/bin/sh

set -e

echo "Assigning directory role '${AD_ROLE_NAME}'"

ROLE_AAD=$(az rest --method Get --uri https://graph.microsoft.com/beta/directoryRoles -o json | jq -r '.value[] | select(.displayName == "'"$(echo ${AD_ROLE_NAME})"'") | .id')
 
URI=$(echo  "https://graph.microsoft.com/beta/directoryRoles/${ROLE_AAD}/members/\$ref") && echo " - uri: $URI"

# grant AAD role to the AAD APP
JSON=$( jq -n \
            --arg uri_role "https://graph.microsoft.com/beta/directoryObjects/${SERVICE_PRINCIPAL_OBJECT_ID}" \
        '{"@odata.id": $uri_role}' ) && echo " - body: $JSON"

az rest --method POST --uri $URI --header Content-Type=application/json --body "$JSON"

echo "Role '${AD_ROLE_NAME}' assigned to azure ad application"