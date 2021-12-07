# Ansible playbook to backup and restore HCL Digital Asset Management (DAM)

**NOTE:** Everything here is provided on an as-is basis! Use it at your own risk! No support, liability  or any other responsibility granted.

This playbook is intented to ease and automate the backup and restore of the HCL Digitial Asset Management data as per [Back up and restore a DAM image](https://help.hcltechsw.com/digital-experience/9.5/digital_asset_mgmt/helm_dam_backup_restore_image.html#helm_dam_backup_restore_image__helm_database_dam_backup_procedure) in the HCL DX documentation.

## What is needed to run the playbook

To run the playbook you need:

- A working ***helm based***  deployment of HCL DX on OpenShift with DAM installed.
  _Note_: using the playbook on nateive Kubernetes should require minimal changes only
- Setup and configured **oc** and **kubectl** CLI environment
- SSH setup to the Ansible target host as required by Ansible. Specifically you need:
  - SSH key authentication setup
  - NOPWD sudo support for the user used by Ansible
- The playbook itself which can be found in the **damBackup** folder of my project [Github ansible](https://github.com/hhue13/ansible). As this is still WiP you might need to checkout the development branch there as well.

## Setup of Ansible environment

I addition to the standard setup of Ansible you need to install and setup the following software:

- Python
  - `pip` / `pip3` depending on the python version being used
  - Python's `requests-oauthlib` module
  - Python's `kubernetes` module
- Ansible collections
  - Run: `ansible-galaxy collection install community.okd`
  - Run: `ansible-galaxy collection install kubernetes.core`

# Setup variables

You need to customize the variables in the following files:

- globalVars
- group_vars/crchosts
- ansible-files/inventory

**Note**: Read the following [README.md](../README.md) for information on encrypting passwords in the variables files

Before running this play-book you need to update the following files and adjust them to your environment:

* [ansible-files/inventory](ansible-files/inventory): Set the host group on which OpenShift is running is called _crchosts_ . There you set the name of the host where _oc_ & _kubectl_ is deployed and which must be setup for Ansible deployment
* [globalVars](globalVars): In this file set the Login URLs for OpenShift and the OS user under which the play-book should be executed
* [group_vars/crchosts](group_vars/crchosts): In the file set the envirnment specific values like the where to store the backups, which databases and directories should be backed up etc.
  **Note**: You need to set the name of the backup files before running the restore via the properties *restoreDirectories* and *restoreDatabases*

## Running the playbook

1. The playbook is written to use tags for specific steps. These are:

* *backup* - Create a backup of the DAM data
  To run the backup of the data run: `ansible-playbook  --tags backup -e @globalVars backupDam.yaml`
* *restore* - Restore _previously_ backed update to the current deployment
  To run the backup of the data
* run: `ansible-playbook  --tags restore -e @globalVars backupDam.yaml`
  **NOTE**: Don't forget to set the files to restore via the variables *restoreDirectories* and *restoreDatabases* **before** running the restore. These files must be available in the direcory set via the variable _targetDirectoryForBackupFiles_

## Verifying the backup

After a successful run of the backup you should see the backed up data in the directory configured via variable _targetDirectoryForBackupFiles_ in the variables file.

- The database backup (taken from the Postgress pod) follows the following naming: `<database>_<timestamp>.dmp.gz`
- The directory backup taken on the DAM pod follows the following naming: `<directory>_<timestamp>.tar.gz`
