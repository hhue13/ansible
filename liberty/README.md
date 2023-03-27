# Ansible Playbook to install WebSphere- and/or Openliberty optionally with IBM HTTP Server and WebSphere Plugins

This Ansble playbook was written to performs the following tasks:

1. Create the users and groups configred via the values files together with the basic directories for the Liberty / IBM HTTP Server (IHS) installation
2. Install WebSphere Liberty or Openliberty based on the package name
3. Create Liberty profile(s) and server(s) as per the values files
4. Install IBM HTTP Server (IHS) and WebSphere plugings

## Prerequisites

The playbook has been written and tested using the following software.

### Ansible and Python

The playbook was written and tested with **Ansible 2.13.3** using **Python 3.9**.

### Collections

The playbook requires the following collections:

- community.crypto.openssl_pkcs12
- community.general.slack

### Ansible execution environment

Instead of installing the required collections locally it is recommended to use **ansible-navigator** with a predefined Ansible Execution Environment.

The playbook was tested with **ansible-navigator** version **2.2.0** using the [cog-teik-awx-custom-ee](https://github.com/hhue13/cog-teik-awx-custom-ee) execution environment with podman as the container engine.

#### ansible-navigator sample setup

The ansible-navigator was setup using the following **.ansible-navigator.yml**

```yaml
---
ansible-navigator:
  ansible:
    inventory:
      entries:
        - ./ansible-files/inventory
  app: welcome
  mode: stdout
  playbook-artifact:
    enable: True
    replay: /dev/shm/artifact.json
    save-as: /dev/shm/artifact.json
  ansible-runner:
    artifact-dir: /dev/shm/artifact-dir
  execution-environment:
    container-engine: podman
    enabled: true
    image: registry.hub.docker.com/hhue13/cog-teik-awx-custom-ee:0.0.1
    pull:
      policy: missing
    volume-mounts:
      - src: /home/hhuebler
        dest: /tmp/hhuebler
    container-options:
      - "--net=host"
  logging:
    level: warning
    append: False
    file: /dev/shm/ansible-navigator.log

```

---

## "root" requirement

As the playbook executed privileged actions like user creation, directory creation etc. the user running the playbook must be setup so that oit can become root.

## Tags being used for execution

To allow the execution of certain tasks only the playbook can be executed using *tags*.

The following tags are available:

- *all*: As per ansible specification this special tag runs all tags of the playbook
- *prereqs*: Create configured users and base directories
- *install*: Install WebSphere Liberty or Openliberty
- *ihsInstall*: Install IHS + Plugins from the tar.gz package
- *profiles*: Create Liberty profile(s) and server(s)
- *ihsProfiles*: Create IHS servers using template configuration

## Sample execution commands

Run all tasks on the hosts group *libertyHosts* from the inventory file *ansible-files/inventory* using the *k8s* vault secret from file */tmp/hhuebler/ansible_password*.
***Note***: As we are using ansible-vault you need to take the *volume-mount* setting in the **.ansible-navigator.yml** file into consideration to provide the correct location of the file.

```bash
ansible-navigator run liberty.yaml -v -e "HOSTS=libertyHosts" -i ansible-files/inventory -t all --vault-id k8s@/tmp/hhuebler/ansible_password
```


Run the liberty profile creations tasks for the hosts in group *bmiHosts* from the inventory file *ansible-files/inventory*

```bash
ansible-navigator run liberty.yaml -v -e "HOSTS=bmiHosts" -i ansible-files/inventory -t profiles  --vault-id k8s@/tmp/hhuebler/ansible_password
```
