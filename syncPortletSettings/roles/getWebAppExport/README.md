getWebAppExport
===============

This role is used to create the an xmlaccess export XML with the portlets being synchronized.

Requirements
------------

n/a

Role Variables
--------------

This role needs the following variables to be exported:
- roleWpsUser: The portal user name to logon to the portal for xmlaccess
- roleWpsPassword: The portal password for the _roleWpsUser_
- roleWebmodsToBeExported: A list of web-app UIDs being included in the export. I.e. all portlets of these web-app will be sync'ed
- roleGbgScriptsDir: The directory to which the gbgScripts Git Repo is checked out
- roleNS: The OCP Namespace
- roleHost: The OCP Hostname
- roleKey: The OCP API Key used for authentication
- roleDeployment: The OCP Help deployment name (dx-green / dx-blue)
- roleXmlFile: The XML file with the filtered web-apps to be sync'ed
- roleXmlBackupDirOnPod: The directory mounted on the POD to which we create a backup of the roleXmlFile

Dependencies
------------

n/a

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

???

Author Information
------------------

Hermann Huebler
mailto: h.huebler@alpium-it.com

