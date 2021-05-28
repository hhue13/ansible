# Ansible playbook to setup DX on OpenShift Cloud Plattform / CRC

**NOTE:** Everything here is provided on an as-is basis! Use it at your own risk! No support, liability  or any other responsibility granted.

This playbook is intented to ease and automate the deployment of HCLs DX plattform on RedHat's Openshift plattform. Due to resource limitations testing so far was done only on RedHats [CRC - Code Ready Containers plattform](https://www.redhat.com/sysadmin/codeready-containers).

## What is needed to run the playbook

To run the playbook you need:

- An initial vanila setup of OpenShift (OSCP) or CRC. This playbook **does not** setup OSCP / CRC
- Setup and configured **oc** and **kubectl** CLI environment
- SSH setup to the Ansible target host as required by Ansible. Specifically you need:
  - SSH key authentication setup
  - NOPWD sudo support for the user used by Ansible
- Persistent storage for OSCP image registry, DX profile, DAM data etc. Since CF192 HCL Digital exerience containers don't accept predefined PVs anymore but work only with PVS whose stroage provisioner provides the PV. If using NFS the [NFS storage provisioner](../k8snfsprovider/README.md) can be installed before deploying DX
  *Note:* Make sure that permissions on the exportet storage are setup properly
- An LDAP server for authentication
  *Note* THe playbook does not yet provide *htpasswd* authentication setup. Only LDAP.
- The playbook itself which can be found in the **dxOnCrc** folder of my project [Github ansible](https://github.com/hhue13/ansible). As this is still WiP you might need to checkout the development branch there.
- Some configuration files templates which you might need to adapt for your needs and will most likely move to a separate project. Sample configuration files are in projects folder *crcTemplates*. Note that these templates must be available on the Ansible target system. I.e. the system to which Ansible is SSH'ing.
- The HCL docker images
- The HCL docker images being loaded locally as docker images from the downloaded **.tar.gz** files
- An unpacked version of the HCLs script package

## Setup variables

You need to customize the variables in the following files:

- globalVars
- group_vars/crchosts

## Running the playbook

The playbook is written to use tags for specific steps. These are:

- *ldapOauth2* - Configure OSCP to use LDAP authentication.
- *setupRegistry* - Configures persistent storage for the OSCP image registry.
- *restartOscp* - Restart the OSCP environment
- *tagAndPushImages* - Retags the loaded images and pushes them to the OSCP image registry
  *Note:* This is done using docker CLI command which mit differ (docker, podman) based on the environment being used. To change the CLI command update the `dockerCliCommand` variable
- *resourceOverride* - Configures the cluster to overwrite the resource requests configured to allow running the setup on smaller environments with less CPUs (and memory). See the template file `clusterResourceOverride.yaml` for the current overriding values. I'm running my CRC with the following setup and needed that for a smooth deployment:
  ```json
  {
    "consent-telemetry": "yes",
    "cpus": 5,
    "disk-size": 75,
    "memory": 32768,
    "pull-secret-file": "/home/hhuebler/data/crc/pullSecret.yaml"
  }
  ```
- *ToDo:* Make that configurable as well
- *dxHclDeployment* - Deploy DX core component

To run the full playbook run: `ansible-playbook  --tags all -e @globalVars  setupDxOnCrc.yam`.

Alternatively you can run the deployment in single steps. Please see the *roles* subdirectory for the different tags being implemented (tag name being used is the role name).

For example to setup LDAP authentication for the OSCP environment only you can run:

`ansible-playbook --tags ldapOauth2 -e @globalVars  setupDxOnCrc.yaml`

How I setup my CRC using the playbook:

- ansible-playbook --tags ldapOauth2 -e @globalVars  setupDxOnCrc.yaml
- ansible-playbook --tags setupRegistry -e @globalVars  setupDxOnCrc.yaml
- ansible-playbook --tags restartOscp -e @globalVars  setupDxOnCrc.yaml
- ansible-playbook --tags tagAndPushImages -e @globalVars  setupDxOnCrc.yaml
- ansible-playbook --tags resourceOverride -e @globalVars  setupDxOnCrc.yaml
- ansible-playbook --tags dxHclDeployment -e @globalVars  setupDxOnCrc.yaml

**Note:** Sometimes I got failures due to timing issues. Just retrying the tag fixed that in my cases (and don't have time at the moment to investigate furtjer).

# How I setup CRC locally

1. Here is my cheat sheet to setup CRC locally to directory **/vms/crc** with the following directories in my **PATH**:  ~/.crc/bin:~~/.crc/bin/oc:/vms/icp/crc-linux

```bash
crc stop
crc delete -f --clear-cache

~~@nfs01:
cd /nfs01 && rm -rf crcprofile && mkdir crcprofile && chown 1000:1001 crcprofile && sync && ls -altr
cd /nfs02 && rm -rf crcregistry && mkdir crcregistry && chmod 777 . crcregistry && sync && ls -altr
cd /nfs03 && rm -rf crcdamdata && mkdir crcdamdata && chmod 777 . crcdamdata && sync && ls -altr
cd /nfs04 && rm -rf crcpersistence && mkdir crcpersistence && chmod 777 . crcpersistence && sync && ls -altr
cd /nfs05 && rm -rf crcpersistence-ro && mkdir crcpersistence-ro && chmod 777 . crcpersistence-ro && sync && ls -altr
cd /nfs06 && for x in 0 1 2 ; do rm -rf crc-dx-deployment-${x} ; mkdir crc-dx-deployment-${x} ; chown 1000:1001 crc-dx-deployment-${x} ; chmod 777 . crc-dx-deployment-${x}; sync ; done ; ls -altr
~~

rm -rf /vms/crc

mkdir -p /vms/crc/bin
mkdir -p /vms/crc/cache
mkdir -p /vms/crc/machines

cd /vms/crc
tar -xf /download/crc-linux-amd64_1.23.0.tar
crcdir=$(ls -d crc-linux*)
ln -s ${crcdir} crc-linux

mkdir -p ~/.crc
cd ~/.crc
ln -s /vms/crc/cache cache
ln -s /vms/crc/bin bin
ln -s /vms/crc/machines machines

cd ~

crc setup
~/data/bin/startCrc.sh
```

**Note:** Don't forget to cleanup the persistent storage
