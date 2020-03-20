# Initializing the launchpad_opensource

The launchpad opensource has some dependencies on having an Azure Devops organization.

## Azure Devops

### Agent pool

Create an agent pool to host the Azure self-hosted agent created by the landing zone. This self-hosted agent is responsible of deploying the landing zones and connecting to the private interface of the Azure services to deploy and configure the application using an Azure devops pipeline.

The CAF landing zone framework follow a hierarchy of agent pools designed to apply a reduction of privileges

### Personal Access Token

To access the Azure Devops service, the Azure devops container running on the self-hosted agent virtual machine need to authenticate the Azure Devops service using a Personal Access Token or PAT.

The PAT token requires the scope "Read & Manage" on the Agent Pools. 

