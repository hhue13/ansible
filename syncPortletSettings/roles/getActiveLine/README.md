getActiveLine
=============

A role which determines the currenly active line (namespace) based on the route being passed. Of the route is found in a namespace it is considered to be the active line/namespace. When the role finishes successfully it sets the following facts:

- activeNamespace
- activeDeployment
- inActiveNamespace
- inActiveDeployment

Requirements
------------

n/a

Role Variables
--------------

The role required the following variables being passed:

- roleActiveRouteName: Name of the route indicating that it's existence in the namespace makes it the active namespace
- roleDeployments: A list of dictionaries with the namespace and deployment names being checked. The list entries have the following keys:

  ```yaml
  roleDeployments:
    - namespace: dxb
      deployment: dx-blue
    - namespace: dxg
      deployment: dx-green
  ```
- roleHost: The OCP Hostname
- roleKey: The OCP API Key used for authentication

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
