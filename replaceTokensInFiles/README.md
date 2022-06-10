# Purpose of this play-book

Helm values files often contain passwords or other secret data which should not be checked into SCM repositories. Therefore this playbook has been created so that we can put placeholder tags in the helm charts which are commited to the SCM repo. Before using the values files we can then check out a specific branch, version tag etc. and replace the placholders with the values of the secrects which are encrypted using ansible-vault and the resulting files are stored in a local directory for use with **helm**.

# Limitations

1. This play-book is indented to run on localhost only
2. This play-book is not fit to run on AWX
3. If the variable *gitPrivateKey* is pointing to a private key with a password then this key must be loaded into an ssh-agent before and the environment variable *SSH_AUTH_SOCK* must be set. If you are using a private key without a passphrase you of course don't need to take care of this :)

# Prerequisites

The following pre-requisites must be met to use the play-book

## Required Ansible collections

The following collections are required to run the playbook:

- ansible.posix
- community.general

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
ansible-playbook  --vault-id k8s@~/ansible_password ./replaceTokens.yaml
```

To run the play-book to set the variable *gitBranch* to *master* (overwriting the value set in group_vars/crchosts) run:

```bash
ansible-playbook  --vault-id k8s@~/ansible_password -e gitBranch=master ./replaceTokens.yaml
```
