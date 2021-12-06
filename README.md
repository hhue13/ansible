# Ansible samples and implementations

**NOTE:** Everything here is provided on an as-is basis! Use it at your own risk! No support, liability  or any other responsibility granted.

The following ones might be interesting:

- [Backup and Restore DAM data](damBackup/README.md)

Left over for historical reasons

- [Deploy the NFS strorage provisioner to OCP](k8snfsprovider/README.md)
- [Deploy HCL Digital Experience to OCP](dxOnCrc/README.md)

# Authentication when using the K8S run books

1. For the K8S access the following environment variables are in use:

- *K8S_API_TOKEN* This environment variable is supposed to be set to a valid sign on token for the cluster. If this environment variable is set no further login attempt is made
- *K8S_USER* This environment variable should contain the user being used to login to the cluster in case _K8S_API_TOKEN_ is not set. If neither _K8S_API_TOKEN_ nor _K8S_USER_ is set the user is setup to the value of the variable _oscpKubeAdminUserName_
- *K8S_PASSWORD* This environment variable should contain the *password* being used to login the user determined via the environment variable _K8S_USER_ or the ansible variable _oscpKubeAdminUserName_. If _K8S_PASSWORD_ is not set the ansible variable _oscpKubeAdminPassword_ is used
- *K8S_HOST_URL* This environment variable contains the URL of the cluster to be accessed. if _K8S_HOST_URL_ is not set or emtpy the global variable *oscpHostApiUrl* is used as host URL

**Note:** To login to Kubernetes the environment variables have preference over the variabls in the variable files. Target is to avoid requirement to store environment specific credentials / URLs in the SCM environment.

## Encrypting passwords in variable files

To secure the passwords in the variables files you can use [Ansible vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) to encrypt the password. As a quick guide to set this up perform:

- Create a file `~/ansible_password` containing the password key used to encrypt the password. Keep this file secret and make sure it's protected
- Update the file mode to `600` by running `chmod 600 ~/ansible_password`
- Encrypt the plain text password by running: `ansible-vault encrypt_string --vault-id k8s@~ansible_password '<plain-text-password>' --name 'oscpKubeAdminPassword'`
- Add the encrypted password variable to your variables file
- Specify the vault-id when invoking the playbook by specifying `--vault-id k8s@~/ansible_password`
