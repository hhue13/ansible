# AWX export / import Playbook
As we are using and relaying on AWX for the daily operations but don't have any automation to set this up this playbook show allow us to export the existing assets from AWX to a JSON file and allow us to import it later on (with some modifications). For the export / import of the AWX assets we are using [Ansible's awx.awx collection](https://docs.ansible.com/ansible/latest/collections/awx/awx/index.html) modules.

## Variables settings
As in the other playbooks we are using we have a _group_vars/crchosts_ file with some variables to set. The comments in the file and the name of the variables should explain the respective meaning.

## Export of the existing assets
To export the existing assets we need to run the playbook with the **export** tag. The playbook then exports all assets to a JSON file in the directory specified in the variable `exportsFileDirectory`. The name of the file being created is the value of the variable `<exportsFile>_<timestamp>.json`.

When the export finished successfully the name specified in the vars for the file being using when importing (`importFileDir`/`importFile`) is linked to the most recent export. I.e. by default always the most recently exported data will be imported again.

## Import of exported assets
I my mistake anything went wrong in AWX with the assets we can import them again.

However there are some limitations:
1. Only assets being exported can be imported again.
2. Certain settings of the AWX setup itself can't be imported again. So these need to be setup manually again in case of a data loss.
3. Before importing assets the JSON file being imported needs to be edited namely
   1. For **ssh** credentials the `ssh_key_data` must be set to contain the private key of the user. The private key must be entered as a _one line string_ i.e. the new line characters must be replaced by ***\n***. See this [gist](https://gist.github.com/pepoviola/6c524769ecbcd15039fe) how this can be done
   2. Passwords of user and credentials are exported as **"$encrypted$"** and need to be set again (maybe just to a default value) to be able to import the data again


__Note__: We are exporting all assets. If you'd like to import only certain assets again it should work by editing the import file (and removing everything you don't want to import)