# Ansible play-book to deploy K8S NFS storage provisioner

**N O T E**

> This is meanwhiel **outdated** !!

> Please use the helm chart based deployment of the [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisionernfs-subdir-external-provisioner) instead.

**N O T E**

**NOTE:** Everything here is provided on an as-is basis! Use it at your own risk! No support, liability  or any other responsibility granted.

This Ansible play-book can be used to install / uninstall the K8S NFS storage provider on OpenShift deployments.

## Prepare the variables

Before running this play-book you need to update the following files and adjust them to your environment:

* [ansible-files/inventory](ansible-files/inventory): Set the host group on which OpenShift is running is called _crchosts_ . There you set the name of the host where _oc_ & _kubectl_ is deployed and which must be setup for Ansible deployment
* [globalVars](globalVars): In this file set the Login URLs for OpenShift and the OS user under which the play-book should be executed
* [group_vars/crchosts](group_vars/crchosts): In the file set the envirnment specific values like the data for your NFS server, login info etc.

## Install the K8S NFS storage provisioner

To run the ansible play-book to install the NFS provisioner perform the following steps:

- `cd <path>/k8snfsprovider`
- `ansible-playbook -e @globalVars k8snfsprovider.yaml --tags "install"`

## Remove the K8S NFS storage provisioner

To run the ansible play-book to remove the NFS provisioner perform the following steps:

- `cd <path>/k8snfsprovider`
- `ansible-playbook -e @globalVars k8snfsprovider.yaml --tags "remove"`
