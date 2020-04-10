# Introduction to level 0 launchpads

Welcome to Cloud Adoption Framework for Azure landing zones for Terraform samples.

The level 0 launchpads allow you to manage the foundations of landing zone environnement like:

- Secure remote Terraform states storage for multiple subscriptions.
- Managing the transition from manual to automation environnement.

To get more background on Cloud Adoption Framework for Azure landing zones for Terraform, please refer to the following [documentation](https://github.com/Azure/caf-terraform-landingzones/tree/master/documentation)

## Which launchpad to use

We are providing a set of launchpads with various capabilities and features:

| Launchpad name                                                             | Capabilities                                                                        | Supported subscription types           |
| ---------------------------------------------------------------------------| ------------------------------------------------------------------------------------| ---------------------------------------|
| [launchpad_opensource](./launchpads/launchpad_opensource)                  | Entreprise support with multi-user collaboration, needs Azure AD admin privileges   | EA, MSDN.                              |
| [launchpad_opensource_light](./launchpads/launchpad_opensource_light)      | Best for mono-user support, no need to Azure AD privileges                          | EA, CSP, AIRS, MSDN, Trial and passes. |

## How to use launchpads

Launchpads are typically included in [rover](https://github.com/aztfmod/rover) releases and can be launched directly from the rover:

```bash
launchpad /tf/launchpads/launchpad_opensource_light apply
```

Launchpad should remain active in a subscription as long as you want to maintain the Terraform life cycle of an environnement. After done with testing, you can simply remove a launchpad using the destroy command as follow:

```bash
launchpad /tf/launchpads/launchpad_opensource_light destroy
```

## Transitioning from manual steps to 100% automation

The problem the launchpad is solving is the transition from manual steps to manage the lifecycle of your Azure infrastructure services to automated, tested and secured lifecycle management of your landing zones. The main challenges customers are facing when starting their journey to the cloud is to define the logical steps to follow to enable the cloud services and get their first applications live into production. That journey can be quite long depending on the complexity of the organization, internal compliance processes and regulation imposed to the industry.

The Microsoft Cloud Adoption Framework defines various steps to help the customer defining that journey and for each steps include guidance, checklist and recommendations. The objectives of the CAF Terraform Landing Zones is to provide an Azure environment that will help the customer accelerate that adoption journey by learning through building and deploying landing zones and blueprints.

Infrastructure as Code (IaC) needs an environment landscape to enable innovation without impacting a development or production environment. Therefore embracing the software industry best practices like building artifacts, using semantic versioning, testing through different dimensions like integration, performance, reliability, disaster recovery, load and releasing to non-production and production is the new norm to deliver enterprise-grade IaC.

The successful implementations tend to focus on building first a sandpit / innovation hub environment where all the stakeholders (IT operations, security, compliance, information protection, finance and business) define their requirements. The DevOps team build, automate, test modules, blueprints and landing zones to create an infrastructure environment that is good enough.

The CAF open source landing zones deliver those services to enable multiple DevOps developers to co-create, reuse and configure the various parts of the landing zones:

* <b>CAF curated modules</b> - is a set of community-driven terraform module written for a production grade environment. They are the building blocks of the blueprints. They include the traditional non-function requirements (NFR) like diagnostics, naming convention, tagging, cost management and security to name few of them. The modules guarantee some consistency across all blueprints. For example a module can be a virtual machine, a SQL database.
* <b>CAF blueprints</b> - the blueprints or terraform services consumes multiples CAF curated modules to build an infrastructure solution. There are some examples in the CAF Terraform edition of public blueprints shared mainly to show our customers how to build a blueprint. Blueprints can be private. Some partner are already building industry specific blueprints. In the CAF Terraform framework we have different categories of blueprints like governance, security, operations, networking or infrastructure platforms like Azure Kubernetes Services, SAP HANA or Azure Web App to name few of them.
* <b>CAF landing zone</b> - a landing zone orchestrates the deployment of multiple blueprints. It targets an Azure subscription to deploy the landing zones.

## Additional launchpads

We are currently working on the support for additional landing zones supporting Hashicorp Terraform Enterprise and Hashicorp Terraform Cloud, feel free to reach out to us if you are willing to contribute in those area or any other improvement areas.

## Contribute
Pull requests are welcome to evolve the framework and integrate new features.
