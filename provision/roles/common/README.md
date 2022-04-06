common
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-common.svg?branch=master)](https://travis-ci.org/wate/ansible-role-common)

ユーザーの追加や基本パッケージのインストールなど、サーバーの共通セットアップ処理を行います。

Role Variables
--------------

### common_groups

サーバーに登録/削除するグループを指定します。

```yml
common_groups:
  - name: group1
  - name: group2
    remove: true
  - name: system_group
    system: true
  - name: system_group_with_id
    id: 1000
    system: true
```

### common_users

サーバーに登録/削除するユーザーを指定します。

```yaml
common_users:
  - name: sample_user
    # Optional
    password: "{{ 'password'|password_hash('sha512') }}"
    groups:
      - group1
      - group2
    authorized_keys:
      - "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
      - https://github.com/hoge.keys
    shell: /bin/nologin
    id: 100000
    system: true
    admin: false
    remove: true
```

### common_packages

インストールする基本パッケージを指定します。

```yaml
common_packages:
  - unzip
  - zip
  - perl
  - cpp
  - make
  - autoconf
  - automake
  - diffstat
  - m4
  - libtool
  - gcc
  - gcc-c++
  - patch
  - git
  - yum-utils
  - vim-enhanced
  - bash-completion
  - tig
```


### common_hostname

ホスト名を指定します。

```yml
common_hostname: "{{ inventory_hostname }}"
```




### common_ssh_port: 22

SSHのポート番号を指定します。
※この設定はfirewalldのSSHのポート番号の解放に利用されます。

```yml
common_ssh_port: 22
```

### common_ssh_use_geoip_filter

GeoIPによるSSHの接続元制限を行うか否かを指定します。

```yml
common_ssh_use_geoip_filter: true
```

### common_ssh_allow_countries

SSHの接続を許可する国コードを指定します。  
この設定は`common_ssh_use_geoip_filter`が`true`に設定されている場合にのみ有効です。

```yml
common_ssh_allow_countries:
  - JP
```

### common_cron_geoip_update

GeoIPデータベースの更新を行う日時を指定します。

```yml
common_cron_geoip_update:
  hour: 4
  minute: 0
```

### fail2ban_jail_cfg

fail2banの設定を定義します。

```yaml
fail2ban_jail_cfg:
  sshd:
    enabled: yes
```

### sudo_require_password

sudoで実行を行う場合にパスワードを求めるか否かを指定します。

```yaml
sudo_require_password: no
```

### yum_cron_daily_cfg

yum-cronの日次処理の設定を指定します。

```yml
yum_cron_daily_cfg: 
  ## Update Setting
  - section: commands
    name: update_cmd
    # default / security / security-severity:Critical / minimal / minimal-security / minimal-security-severity:Critical
    value: default
  - section: commands
    name: update_messages
    value: "yes"
  - section: commands
    name: download_updates
    value: "yes"
  - section: commands
    name: apply_updates
    value: "no"
  - section: commands
    name: random_sleep
    value: 360
  ## Email Setting
  - section: email
    name: email_from
    value: root@localhost
  - section: email
    name: email_to
    value: root
  - section: email
    name: email_host
    value: localhost
```

### yum_cron_hourly_cfg

yum-cronの毎時処理の設定を指定します。

```yml
yum_cron_hourly_cfg: 
  ## Update Setting
  - section: commands
    name: update_cmd
    # default / security / security-severity:Critical / minimal / minimal-security / minimal-security-severity:Critical
    value: default
  - section: commands
    name: update_messages
    value: "no"
  - section: commands
    name: download_updates
    value: "no"
  - section: commands
    name: apply_updates
    value: "no"
  - section: commands
    name: random_sleep
    value: 15
  ## Email Setting
  - section: email
    name: email_from
    value: root
  - section: email
    name: email_to
    value: root
  - section: email
    name: email_host
    value: localhost
```


### common_swap_dest

スワップファイルのパスを指定します。
※この設定はスワップが存在しない場合のみ有効です。

```yml
common_swap_dest: /var/spool/swap/swapfile
```

### common_swap_size

スワップのサイズを指定します。
※この設定はスワップが存在しない場合のみ有効です。

```yml
common_swap_size: "{{ (((ansible_memtotal_mb + 50) / 1000) | round(1, 'floor') | float * 2) | int }}"
```

### common_files

任意のファイルをアップロードまたはダウンロードし配置します。

```yml
common_files: 
  # ローカルにあるファイルをアップロード
  - dest: /usr/local/bin/upload-script
    src: path/to/script
    mode: "0755"
    # owner: root
    # group: root
    # checksum: 1234567890abcdefghijklmnopqrstuvwxyz
  # リモートファイルをダウンロード
  - dest: /usr/local/bin/download-script
    url: http://www.example.com/path/to/script
    mode: "0755"
    # owner: root
    # group: root
    # auth_basic_user: user
    # auth_basic_password: password
    # checksum: 1234567890abcdefghijklmnopqrstuvwxyz
  # 既存のファイルを削除
  - dest: /usr/local/bin/batch-script
    ## ※この属性が指定されている場合は設定値の如何に関わらず、ファイルが存在する場合は削除する
    removed: true
```

### common_cron_jobs

cronジョブの設定を行います。

```yml
common_cron_jobs: 
  - name: check ssl expiration date
    ## 定期実行コマンド
    job: cert -f json example.com
    ## 定期実行日時(時)
    hour: 1
    ## 定期実行日時(分)
    minute: 23
    ## 定期実行日時(日)
    # day: "*"
    ## 定期実行日時(月)
    # month: "*"
    ## 定期実行日時(曜日)
    # weekday: "*"
    ## 実行ユーザー
    # user: root
    ## 定期実行設定は残したまま無効化するか否か
    # disabled: true
    ## 定期実行設定の存在の有無(これが指定された場合は値の如何に関わらず、設定が存在する場合は削除します)
    # removed: true
```

### common_cron_vars

cron用の変数を設定します。

```yml
common_cron_vars: 
  - name: PATH
    value: /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
  - name: MAILTO
    value: root
  - name: SHELL
    value: /usr/bin/bash
  - name: HOME
    value: /
    ## 以下が指定された場合は指定の変数を削除します
    # removed: true
```

Example Playbook
----------------

```yaml
- hosts: servers
  roles:
    - role: common
```

License
-------

MIT
