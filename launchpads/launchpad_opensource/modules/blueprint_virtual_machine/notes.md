
Get Azure Devops AccessToken
az account get-access-token --resource https://app.vssps.visualstudio.com

---

curl -X POST https://app.vssps.visualstudio.com/oauth2/token -H "Content-Type: application/x-www-form-urlencoded" 

https://app.vssps.visualstudio.com/oauth2/authorize?client_id=079336BF-B202-426B-806D-14929B29876B&response_type=Assertion&state=User1&scope=vso.serviceendpoint_manage&redirect_uri=https://github.com/aztfmod


vso.agentpools_manage%20vso.build_execute vso.identity_manage vso.securefiles_manage vso.serviceendpoint_manage vso.variablegroups_manage

------
variablegroupid=1
org=azure-terraform
proj=Blueprints

#bearerToken=$(System.AccessToken)
bearerToken=$(az account get-access-token --resource https://app.vssps.visualstudio.com | jq -r .accessToken)
header="Authorization: Bearer $bearerToken"

patToken=`echo -n "terraform:i7kke4ot7klgthobmosa276ojfd7m2gzkd2pjlbwsz7h3lzqyjqq" | base64 -w 0`
header="Authorization: Basic $patToken"

url="https://dev.azure.com/$org/_apis/projects?api-version=5.1"

curl -X GET "$url" -H "Content-Type: application/json" -H "$header"

----


Setting Up Azure Pipelines
For a more detailed discussion on setting up an Azure DevOps / Azure Pipelines CI environment see Continuous Integration with Azure DevOps in the ASWF Sample Project. We will use the Azure CLI to create a corresponding Azure DevOps project:

az extension add --name azure-devops
export AZURE_DEVOPS_EXT_PAT=YOUR_AZDEVOPS_PAT
az devops configure --defaults organization=https://dev.azure.com/AZDEVOPS_ORG_NAME
az devops project create --name AZDEVOPS_PROJECT_NAME --source-control git --visibility public
az devops configure --defaults project=AZDEVOPS_PROJECT_NAME
Create the service connection to the GitHub project:

export AZURE_DEVOPS_EXT_GITHUB_PAT=YOUR_GITHUB_PAT
az devops service-endpoint github create --github-url https://github.com/GITHUB_ACCOUNT/GITHUB_PROJECT/settings --name GITHUB_PROJECT.github.connection

Create the build pipeline:

export GITHUB_CONNECTION_ID=$(az devops service-endpoint list  --query "[?name=='GITHUB_PROJECT.github.connection'].id" -o tsv)
az pipelines create --name GITHUB_PROJECT.ci --repository GITHUB_USER/GITHUB_PROJECT --branch master --repository-type github --service-connection $GITHUB_CONNECTION_ID --skip-first-run --yml-path /a
zure-pipelines.yml



Next save this token to a secret Azure Pipelines secret variable called DOCKER_HUB_TOKEN:

az pipelines variable create --name DOCKER_HUB_TOKEN --value YOUR_DOCKER_HUB_TOKEN --secret true --allow-override true --pipeline-name GITHUB_PROJECT.ci


sed -e 's/DOCKER_HUB_USER/docker-hub-id/' \
    -e 's/DOCKER_HUB_TOKEN/docker-hub-access-token/' \
    -e 's/DOCKER_HUB_EMAIL/docker-hub-email/' \
    -e 's/DOCKER_HUB_CONNECTION/GITHUB_PROJECT.dockerhub.connection/' \
    docker_hub_endpoint.json | \
az devops service-endpoint create --service-endpoint-configuration /dev/stdin
where name-for-service-endpoint corresponds to the containerRegistry property of the Docker@2 task in your azure-pipelines.yml CI configuration file. az devops ... reads the output of sed via /dev/stdin to avoid having to create a temporary file containing cleartext credentials.

Currently az devops service-endpoint create creates a service connection which doesn't have the "Allow all pipelines to use this service connection" property set (which you can set when you create a service connection from the web UI). The comments in this GitHub Issue requesting a feature enhancement propose the use of a generic API, az devops invoke ... as a workaround.

export DOCKER_HUB_CONNECTION_ID=$(az devops service-endpoint list \
    --query "[?name=='name-of-docker-hub-connection'].id" -o tsv)
sed -e 's/DOCKER_HUB_CONNECTION_ID/'$DOCKER_HUB_CONNECTION_ID'/' \
    -e 's/DOCKER_HUB_CONNECTION/name-of-docker-hub-service-endpoint/' \
    docker_hub_endpoint_auth.json | \
az devops invoke --http-method patch --area build --resource authorizedresources \
    --route-parameters project=GITHUB_PROJECT --api-version 5.0-preview --in-file /dev/stdin --encoding ascii


