# Purpose of this play-book
In case  we have a planned shut-down/upgrade/... of the server, we need a mechanism to switch user traffic to an error-page. The technology behind 
is using *Openhift Routes* with the hostname known by the end-user (and set via variable *oscpRouteHostNameToSet*) as the value of the **host** key.

This playbook can be used to switching user traffic between the error-page and the portal by swapping the service endpoint in the route with the 
name set via variable *oscpRouteNameToToggle*. This playbook acts like a toggle swtich.

## How does it work?
I.e. if the route is currently on *green* it will be *removed* from *green* and created on *blue*. If the playbook detects that the route exists on 
*blue* it will *remove* the route from *blue* and recreate it on *green*.

If the route does not exist on any of the environments if will be created using the configred *initial namespace* (via variable 
**oscpIntialNamespaceForRoute** ) and deployment names (via variable **oscpInitialDeploymentForRoute**).


# Limitations
1. If, for whatever reason the route (set via variable *oscpRouteNameToToggle*) exists in both namespace this playbook fails as this is an undefined 
state.
2. This playbook assumed that the command *yq* is available on the *ansible managed node* (set via the Ansible **inventory**). The location can be 
configured via variable **yqBin**.


# Prerequisites
The following pre-requisites must be met to use the play-book

## Installation of yq
This playbook was tested with yq version v4.29.2 from [yq GitHub](https://github.com/mikefarah/yq/releases).

## Required Ansible collections
The following collections are required to run the playbook:
- The playbook is written to work in following Ansible execution environment [cog-teik-awx-custom-ee>](https://github.com/hhue13/cog-teik-awx-custom-ee)

## Slack
The playbook is capable to send notifications to a slack channel (variable: *sendSlackNotifications*). This requires that:
- The variable *slackAuthenticationToken*  ([token-0]/[token-1/[token-2]) is encrypted in the variables files
- the *ansible.cfg* is setup to enable the slack callback like for example:
- ```bash
  [callback_slack]
  webhook_url = https://hooks.slack.com/services/[token-0]/[token-1/[token-2]
  validate_certs = no
  channel = #myansible
  ```


# Sample executions
To run the play-book with the variables set in group_vars/crchosts
```bash
ansible-playbook --vault-id k8s@~/ansible_password -e @globalVars.yaml toggleRoute.yaml
```
