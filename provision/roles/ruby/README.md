ruby
=========

Rubyの基本パッケージをインストールします。

Role Variables
--------------

### ruby_packages

Rubyの基本パッケージを設定します。

#### Example

```yml
ruby_packages:
  - ruby
  - ruby-dev
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - role: ruby
```

License
-------

MIT
