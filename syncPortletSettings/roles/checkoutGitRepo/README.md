checkoutGitRepo
===============

This role checks out a Git Repo via SSH to a provided directory

Requirements
------------

Environment variable **SSH_AUTH_SOCK** must be set.

Role Variables
--------------

- roleGitSource: Dictionary with the following keys:
  ```yaml
  roleGitSource:
    gitPrivateKey: "<file with the ssh private key used to checkout>"
    gitRepositoryUrl: "<ssh repository URL>"
    gitBranchOrVersion: "<branch/tag/commit to checkout>"
    gitRemote: "origin"
  ```
- roleCheckoutDest: The path to which the Git repo should be checked out
- roleCheckoutUmask: umask to be used for the checked out repo. Defaults to "022"

Dependencies
------------

The path provided in the _roleCheckoutDest_ value must exist

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
