# Permissions

This document explains the main security requirements to initialize the launchpad. The main objective of the launchpad is to delegate the execution of the Azure landing zone in a least privilege environment. In order to achieve that the initial execution of the launchpad also called bootstrap requires high privileges to provision the resources who will be in charge of the subsequent executions of the launchpad. During that initial deployment the launchpad install all Azure services required to store the Terraform remote states of the landing zones and relates services to enable a collaboration DevOps environment through the Azure CAF rover.

As a matter of clarity the process could be described as follow

Initial execution (using the launchpad command line tool)

- (high privileged user) --> (deploy the launchpad) --> (Create Azure AD app, Azure AD Groups, Azure resources, Set permission set to the launchpad Azure AD app)

Subsequent executions to deploy landing zones (using the rover command line tool)

- (members of the Azure AD launchpad group) --> (Delegate execution to the launchpad app) --> (deploy the terraform landing zones)

The main requirements to perform the initial execution of the launchpad are:

- High privileges on the Azure Directory Tenant
- Subscription ownership of the subscription owning the launchpad

The launchpad creates an Azure AD application that will be in charge of the deployment of the terraform landing zones. There are different scenario that have been tested. Depending on your roles in the Azure AD tenant and Azure first  subscription you may have to adjust your permission set to execute some of tha landing_zones.

You can find the step-by-step procedure [here](./setup_prereqs.md).

## Active Directory

The bootstrap flow perform the following actions:

- Create an Azure AD application (launchpad). Assign Azure AD Graph API permissions to Read the Directory and manage Azure AD applications,
- Assign the launchpad subscription ownership

The ideal way to bootstrap the launchpad is to request a Global Administrator role who also has permissions on the Azure Management Group root. If those privileges cannot be assigned to the user in charge of running the launchpad on the first run then those minimum privileges are required.

## Azure subscription for the launchpad

### Subscription Contributor

As an Azure subscription contributor you require an additional set of permissions as described in the following table. Those permissions must be set to the Azure AD launchpad

| Terraform object | Permission | Scope | Description |
| -- | -- | -- | -- |
| storage_blob_contributor | Microsoft.Authorization/roleAssignments/write<br>Microsoft.Authorization/roleAssignments/Read | storage account  | Permissions are granted at the Azure blob storage level as blob storage contributor |
| launchpad_role1 | Microsoft.Authorization/roleAssignments/write<br>Microsoft.Authorization/roleAssignments/Read | /subscriptions/{subscription_id} | the launchpad create an Azure AD application and assign it ownership to the subscription.|
