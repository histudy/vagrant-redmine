nodejs
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-nodejs.svg?branch=master)](https://travis-ci.org/wate/ansible-role-nodejs)

Node.jsをインストールします

Role Variables
--------------

### nodejs_major_version

インストールするNode.jsのメジャーバージョンを指定します

```yaml
nodejs_version: 12
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - role: nodejs
```

License
-------

MIT
