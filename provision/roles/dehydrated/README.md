dehydrated
=========

[![Build Status](https://travis-ci.org/wate/ansible-role-dehydrated.svg?branch=master)](https://travis-ci.org/wate/ansible-role-dehydrated)

[dehydrated](https://github.com/lukas2511/dehydrated)のインストールとセットアップを行います。

Role Variables
--------------

### dehydrated_cfg

dehydratedの設定内容を指定します。

```yml
dehydrated_cfg:
  challengetype: http-01
#   user: ""
#   group: ""
#   ca: https://acme-v02.api.letsencrypt.org/directory
#   oldca: ""
#   keysize: 4096
#   openssl_cnf: ""
#   openssl: openssl
#   curl_opts: ""
#   hook_chain: false
#   renew_days: 30
#   private_key_renew: true
#   private_key_rollover: false
#   key_algo: rsa
#   contact_email: ""
#   ocsp_must_staple: false
#   ocsp_fetch: false
#   auto_cleanup: false
#   api: auto
```

### dehydrated_domains

Let's Encryptで証明書を取得するドメインを指定します。

```yml
dehydrated_domains:
    - name: example.com
      domains:
        - example.com
        - *.example.com
    - name: example.net
      domains: example.net
```

### dehydrated_auto_execute

プロビジョニング実行時にdehydratedの実行を行うか否かを指定します。

```yml
dehydrated_auto_execute: true
```

### dehydrated_cron

cronで実行する証明書の更新処理の実行時刻を指定します。

```yml
dehydrated_cron:
  hour: "{{ 23|random }}"
  minute: "{{ 59|random }}"
```

### dehydrated_hook_initialize

フックスクリプトの初期化処理を指定します。

```yml
dehydrated_hook_initialize: |
    export PROVIDER=${PROVIDER:-"cloudflare"}
```

### dehydrated_hook_deploy_challenge

deploy_challengeフック呼び出し時の実行内容を指定します。

```yml
dehydrated_hook_deploy_challenge: |
    lexicon $PROVIDER create ${DOMAIN} TXT --name="_acme-challenge.${DOMAIN}." --content="${TOKEN_VALUE}"
```

### dehydrated_hook_clean_challenge

clean_challengeフック呼び出し時の実行内容を指定します。

```yml
dehydrated_hook_clean_challenge: |
    lexicon $PROVIDER delete ${DOMAIN} TXT --name="_acme-challenge.${DOMAIN}." --content="${TOKEN_VALUE}"
```

### dehydrated_hook_deploy_cert

deploy_certフック呼び出し時の実行内容を指定します。

### dehydrated_hook_unchanged_cert

unchanged_certフック呼び出し時の実行内容を指定します。

### dehydrated_hook_invalid_challenge

invalid_challengeフック呼び出し時の実行内容を指定します。

### dehydrated_hook_request_failure

request_failureフック呼び出し時の実行内容を指定します。

### dehydrated_hook_generate_csr

generate_csrフック呼び出し時の実行内容を指定します。

### dehydrated_hook_startup_hook

startup_hookフック呼び出し時の実行内容を指定します。

### dehydrated_hook_exit_hook

exit_hookフック呼び出し時の実行内容を指定します。

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - role: dehydrated
```

License
-------

Apache License 2.0
