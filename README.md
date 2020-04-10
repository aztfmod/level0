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

## Additional landing zones

We are currently working on the support for additional landing zones supporting Hashicorp Terraform Enterprise and Hashicorp Terraform Cloud, feel free to reach out to us if you are willing to contribute in those area or any other improvement areas.

## Contribute
Pull requests are welcome to evolve the framework and integrate new features.
