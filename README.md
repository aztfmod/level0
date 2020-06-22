# Introduction to launchpads

Welcome to the [Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/) for Azure landing zones for Terraform samples.

The launchpads allow you to manage the foundations of landing zone environments by:

- Securing remote Terraform state storage for multiple subscriptions.
- Managing the transition from manual to automated environments.

For background on the Cloud Adoption Framework for Azure landing zones for Terraform, please refer to the following [documentation](https://github.com/Azure/caf-terraform-landingzones/tree/master/documentation).

## Which launchpad to use

We provide a set of launchpads with various capabilities and features:

| Launchpad name                                                             | Capabilities                                                                        | Supported subscription types           |
| ---------------------------------------------------------------------------| ------------------------------------------------------------------------------------| ---------------------------------------|
| [launchpad_opensource](./launchpads/launchpad_opensource)                  | Enterprise support with multi-user collaboration. Needs Azure AD admin privileges.   | EA, MSDN.                              |
| [launchpad_opensource_light](./launchpads/launchpad_opensource_light)      | Best for mono-user support. No need to Azure AD privileges.                          | EA, CSP, AIRS, MSDN, Trial and passes. |

## How to use launchpads

Launchpads are typically included in [rover](https://github.com/aztfmod/rover) releases and can be launched directly from the rover:

```bash
launchpad /tf/launchpads/launchpad_opensource_light apply -var location=<azure_region_to_deploy>
```

The launchpad should remain active in a subscription as long as you want to maintain the Terraform lifecycle of the environment. If for some reason the launchpad needs to be rmeoved, you can simply use the following command:

```bash
launchpad /tf/launchpads/launchpad_opensource_light destroy
```

## Transitioning from manual steps to 100% automation

The main challenge customers face when starting their journey to the cloud is to identify and complete the required steps to build a production-grade cloud infrastructure that can support their first applications or services.  This challenge only continues to grow with the increasing complexity of organizations, internal change management processes, and regulations imposed on industries.  The Microsoft Cloud Adoption Framework defines those steps and includes guidance, checklists and recommendations for each step. 

The primary objective of CAF Terraform landing zones is to provide an automated approach that accelerates the adoption journey by learning through building and deploying landing zones and blueprints. 

Launchpads are the first step in that journey and the transition from manual steps to managing the lifecycle of Azure services using automated, tested and secured methods. 

### Infrastructure as Code (IaC) 

Infrastructure as Code (IaC) requires an environment landscape that can enable innovation without impacting development or production environments. Certain industry best practices must be embraced and become the new norm in order to deliver enterprise grade IaC: 
* Building artifacts
* Semantic versioning
* Testing through different dimensions like integration, performance, reliability and load
* Disaster recovery
* Release promotion

Successful IaC implementations tend to focus on building a sandpit / innovation hub environment first, where all the stakeholders (IT operations, security, compliance, information protection, finance and business) define their respective requirements and the DevOps team builds, automates, and tests the modules, blueprints and landing zones.

## Additional launchpads

We are currently working on support for additional landing zones that use HashiCorp Terraform Enterprise and HashiCorp Terraform Cloud. Feel free to reach out to us if you are willing to contribute in those areas or any other improvement areas.

## Contribute
Pull requests are welcome to evolve the framework and integrate new features.
