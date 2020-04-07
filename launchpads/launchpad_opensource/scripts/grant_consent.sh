#!/bin/sh

set -e

function grant_consent {

    resourceId=$1
    principalId=$2
    appRoleId=$3

    URI=$(echo  "https://graph.microsoft.com/beta/servicePrincipals/${resourceId}/appRoleAssignments") && echo " - uri: $URI"

    # grant consent (Application.ReadWrite.OwnedBy)
    JSON=$( jq -n \
                --arg principalId "${principalId}" \
                --arg resourceId "${resourceId}" \
                --arg appRoleId "${appRoleId}" \
            '{principalId: $principalId, resourceId: $resourceId, appRoleId: $appRoleId}' ) && echo " - body: $JSON"

    az rest --method POST --uri $URI --header Content-Type=application/json --body "$JSON"
}

USER_TYPE=$(az account show --query user.type -o tsv)
if [ ${USER_TYPE} == "user" ]; then
    echo "granting consent to logged in user"
    az ad app permission admin-consent --id ${APPLICATION_ID}

    echo "Initializing state with user: $(az ad signed-in-user show --query userPrincipalName -o tsv)"
else
    echo "granting consent to logged in service principal" - Need to use the beta rest API for service principals. not supported by az cli yet

    ADGRAPHID=$(az ad sp show --id "${active_directory_graph_id}" --query "objectId" -o tsv)

    echo "grant consent (Application.ReadWrite.OwnedBy):"
    grant_consent "${ADGRAPHID}" "${SP_ID}" "${active_directory_graph_resource_access_id_Application_ReadWrite_OwnedBy}"
   
    echo "\ngrant consent (Directory.Read.All):"
    grant_consent "${ADGRAPHID}" "${SP_ID}" "${active_directory_graph_resource_access_id_Directory_ReadWrite_All}"


    MSGRAPHID=$(az ad sp show --id "${microsoft_graph_id}" --query "objectId" -o tsv)   

    echo "\ngrant consent (AppRoleAssignment.ReadWrite.All):"
    grant_consent "${MSGRAPHID}" "${SP_ID}" "${microsoft_graph_AppRoleAssignment_ReadWrite_All}"

fi