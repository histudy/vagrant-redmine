redmine
=========

[Redmine](http://www.redmine.org/)のインストールとセットアップを行います。

Role Variables
--------------

### redmine_version

インストールするRedmineのバージョンを指定します。

```yml
redmine_version: "3.4-stable"
```

### redmine_db_cfg

データベースの接続情報を指定します。

```yml
redmine_db_cfg:
  production:
    adapter: mysql2
    database: redmine
    host: localhost
    username: redmine_user
    password: redmine_password
    encoding: utf8
```

### redmine_cfg

Redmineのシステム設定を指定します。

```yml
redmine_cfg:
  default:
    email_delivery:
      delivery_method: :sendmail
    attachments_storage_path:
    autologin_cookie_name:
    autologin_cookie_path:
    autologin_cookie_secure:
    scm_subversion_command:
    scm_mercurial_command:
    scm_git_command:
    scm_cvs_command:
    scm_bazaar_command:
    scm_darcs_command:
    scm_subversion_path_regexp:
    scm_mercurial_path_regexp:
    scm_git_path_regexp:
    scm_cvs_path_regexp:
    scm_bazaar_path_regexp:
    scm_darcs_path_regexp:
    scm_filesystem_path_regexp:
    scm_stderr_log_file:
    database_cipher_key:
    rmagick_font_path: /usr/share/fonts/opentype/ipaexfont-gothic/ipaexg.ttf
```

### redmine_themes

インストールするテーマを指定します。

```yml
redmine_themes:
  - name: gitmike
    repo: "https://github.com/makotokw/redmine-theme-gitmike.git"
  - name: farend_fancy
    repo: "https://github.com/farend/redmine_theme_farend_fancy.git"
  - name: farend_basic
    repo: "https://github.com/farend/redmine_theme_farend_basic.git"
```

### redmine_plugins

インストールするプラグインを指定します。

```yml
redmine_plugins:
  # リポジトリから取得
  - name: view_customize
    repo: "https://github.com/onozaty/redmine-view-customize.git"
    # プラグインのディレクトリ名を指定
    directory: view_customize
  - name: issue_templates
    repo: "https://github.com/akiko-pusu/redmine_issue_templates.git"
  - name: slack
    repo: "https://github.com/sciyoshi/redmine-slack.git"
  - name: chatwork
    repo: "https://github.com/wate/redmine_chatwork.git"
  - name: dashboard
    repo: "https://github.com/jgraichen/redmine_dashboard.git"
    # 取得するバージョンまたはブランチを指定(省略時はmasterブランチの内容を取得)
    version: stable-v2
  # URLから取得
  - name: easy_gantt
    url: "http://www.easyredmine.com/packages/EasyGanttFree.zip"
  # ファイルをアップロード
  - name: agile
    file: path/to/redmine_agile-light.zip
  - name: checklists
    file: path/to/redmine_checklists-light.zip
  - name: plantuml
    repo: "https://github.com/dkd/plantuml.git"
    directory: plantuml
    # プラグインが依存するパッケージ
    required_packages:
      - plantuml
  - name: periodic_task
    repo: "https://github.com/wate/redmine_periodic_task.git"
    directory: periodictask
    # プラグインのcron設定
    cron:
      command: bundle exec rake redmine:check_periodictasks
      minute: 0
      hour: 1
```

### redmine_lang

Redmineの初期登録データの言語を指定します。

```yml
redmine_lang: ja
```

### redmine_settings

Redmineの設定を指定します。

```yml
redmine_settings:
  ## -------------
  ## 全般
  ## -------------
  ## アプリケーションのタイトル
  # app_title: Redmine
  ## ウェルカムメッセージ
  # welcome_text: |
  #   Redmineの使い方
  #   =======================
  #
  #   以下の内容を把握した上でRedmineを利用しましょう。
  #
  #   チケット種別
  #   -----------------------
  #   チケットの種別を表しています。
  #   ### バグ
  #   不具合(と思われるもの)は、チケット種別にこの値を設定します。
  #   ### 機能
  #   新たに機能を追加するものは、チケット種別にこの値を設定します。
  #   ### サポート
  #   既存機能の改善や保守作業に該当するものは、チケット種別にこの値を設定します。
  #
  #   ステータス
  #   -----------------------
  #   チケットが現在どのような状態かを表しています。
  #   ### 新規
  #   何も対応が行われていない状態です。
  #   ### 処理中
  #   現在対応中の状態です。
  #   ### 解決済み
  #   対応が完了し、対応内容に問題ないかどうか確認中の状態です。
  #   ### 完了
  #   確認が完了し、完了した状態です。
  #   ### 破棄
  #   何も対応を行わず、完了した状態です。
  ## ホスト名とパス
  host_name: "{{ inventory_hostname }}"
  ## プロトコル
  # protocol: http
  ## テキスト書式
  text_formatting: markdown
  ## -------------
  ## 表示
  ## -------------
  ## テーマ
  # ui_theme: ""
  ## デフォルトの言語
  default_language: "{{ redmine_lang }}"
  ## ユーザー名の表示形式
  ## * firstname_lastname：Redmine Admin
  ## * firstname_lastinitial：Redmine A.
  ## * firstinitial_lastname：R. Admin
  ## * firstname：Redmine
  ## * lastname_firstname：Admin Redmine
  ## * lastnamefirstname：AdminRedmine
  ## * lastname_comma_firstname：Admin, Redmine
  ## * lastname：Admin
  ## * username：admin
  user_format: lastname_firstname
  ## Gravatarのアイコンを使用する
  # gravatar_enabled: 1
  ## デフォルトのGravatarアイコン
  # gravatar_default: ""
  ## 添付ファイルのサムネイル画像を表示
  # thumbnails_enabled: 1
  ## サムネイル画像の大きさ(ピクセル単位)
  # thumbnails_size: 100
  ## -------------
  ## 認証
  ## -------------
  ## 認証が必要
  # login_required: 1
  ## 自動ログイン
  # autologin: ""
  ## -------------
  ## API
  ## -------------
  ## RESTによるWebサービスを有効にする
  # rest_api_enabled: 1
  ## JSONPを有効にする
  # jsonp_enabled: 1
  ## -------------
  ## プロジェクト
  ## -------------
  ## デフォルトで新しいプロジェクトは公開にする
  # default_projects_public: 1
  ## 新規プロジェクトにおいてデフォルトで有効になるモジュール
  # default_projects_modules:
  #   - issue_tracking
  #   - time_tracking
  #   - news
  #   - documents
  #   - files
  #   - wiki
  #   - calendar
  #   - gantt
  #   - issue_templates
  ## 新規プロジェクトにおいてデフォルトで有効になるトラッカー
  # default_projects_tracker_ids:
  #   - 1
  #   - 3
  ## -------------
  ## ファイル
  ## -------------
  ## 添付ファイルの上限(KB)
  # attachment_max_size: 5120
  ## 添付ファイルとリポジトリのエンコーディング
  # repositories_encodings: "UTF-8,CP932,EUC-JP"
  ## -------------
  ## メール通知
  ## -------------
  ## 送信元メールアドレス
  # mail_from: redmine@example.net
  ## デフォルトのメール通知オプション
  ## * all：参加しているプロジェクトのすべての通知
  ## * only_my_events：ウォッチ中または自分が関係しているもの
  ## * only_assigned：ウォッチ中または自分が担当しているもの
  ## * only_owner：ウォッチ中または自分が作成したもの
  ## * none：通知しない
  # default_notification_option: only_my_events
  ## メールのヘッダー
  # emails_header: |
  #   このメールはRedmineからのメール通知です。
  # emails_footer: |
  #   この通知は「個人設定」の「メール通知」により通知されています。
  #   メール通知を無効にする場合は以下のURLより「個人設定」を開き、
  #   「メール通知」の設定内容を変更してください。
  #   ------
  #   http://{{ inventory_hostname }}/my/account
  #   ------
  ## -------------
  ## リポジトリ
  ## -------------
  ## 使用するバージョン管理システム
  # enabled_scm:
  #   - Git
```

### redmine_send_reminders_cron_job

リマインダーメールの設定を指定します。

```yml
redmine_send_reminders_cron_job:
  enabled: no
  params:
    - 'days=7'
    # - 'tracker=1'
    # - 'users="1,23,45"'
  hour: 9
  minute: 0
```

### redmine_receive_imap_cron_job

メール(IMAP)によるチケット登録の設定を指定します。

```yml
redmine_receive_imap_cron_job:
  enabled: no
  params:
    - "username=imap_acount"
    - "password=imap_password"
    # - host=127.0.0.1
    # - port=143
    # - ssl=false
    # - folder=INBOX
  # hour: "*"
  # minute: "*/5"
```

### redmine_receive_pop3_cron_job

メール(POP3)によるチケット登録の設定を指定します。

```yml
redmine_receive_pop3_cron_job:
  enabled: no
  params:
    - "username=pop3_acount"
    - "password=pop3_password"
    # - host=127.0.0.1
    # - port=110
    # - ssl=false
  # hour: "*"
  # minute: "*/5"
```

### redmine_puma_cfg

Redmineのサービス設定を指定します。

```yml
redmine_puma_cfg:
  bind: "unix://{{ redmine_home }}/tmp/redmine.sock"
  # bind: "tcp://0.0.0.0:9292"
  pidfile: "{{ redmine_home }}/tmp/redmine.pid"
  state_path: "{{ redmine_home }}/tmp/redmine.state"
  stdout_redirect:
    stdout: "{{ redmine_home }}/log/stdout.log"
    stderr: "{{ redmine_home }}/log/stderr.log"
    append: no
  # quiet: no
  threads:
    min: 0
    max: 16
  workers: 2
  # prune_bundler: no
  preload_app: yes
```


### redmine_admin

Redmineの初期システム管理者を設定します。  
※詳細は変数ファイルを参照してください。

### redmine_issue_statuses

Redmineのチケットのステータスを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_trackers

Redmineのトラッカーを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_workflows

Redmineのワークフローを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_roles

Redmineのロールを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_project_custom_fields

Redmineのプロジェクトのカスタムフォールドを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_issue_custom_fields

Redmineのチケットのカスタムフォールドを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_users

Redmineのユーザーを設定します。  
※詳細は変数ファイルを参照してください。

### redmine_projects

Redmineのプロジェクトを設定します。  
※詳細は変数ファイルを参照してください。

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - role: redmine
```

License
-------

MIT
