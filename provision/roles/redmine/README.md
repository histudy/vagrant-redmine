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

### redmine_customize_language

redmineの言語ファイルのカスタマイズ内容を設定します。  
※この変数が定義されている場合、Redmine本体の言語ファイルを書き換えます。

```yml
redmine_customize_language:
  ja:
    error_no_tracker_in_project: このプロジェクトにはチケット種別が登録されていません。プロジェクト設定を確認してください。
    error_workflow_copy_source: コピー元となるチケット種別またはロールを選択してください
    error_workflow_copy_target: コピー先となるチケット種別とロールを選択してください
    error_can_not_delete_tracker: このチケット種別は使用中です。削除できません。
    error_no_tracker_allowed_for_new_issue_in_project: このプロジェクトにはチケットの追加が許可されているチケット種別がありません
    setting_app_title: タイトル
    setting_default_projects_tracker_ids: 新規プロジェクトにおいてデフォルトで有効になるチケット種別
    project_module_documents: ドキュメント
    project_module_news: お知らせ
    label_tracker: チケット種別
    label_tracker_plural: チケット種別
    label_tracker_new: 新しいチケット種別
    label_tracker_all: すべてのチケット種別
    label_document: ドキュメント
    label_document_new: 新しいドキュメント
    label_document_plural: ドキュメント
    label_document_added: ドキュメントの追加
    label_news: お知らせ
    label_news_new: お知らせを追加
    label_news_plural: お知らせ
    label_news_latest: 最新のお知らせ
    label_news_view_all: すべてのお知らせを表示
    label_news_added: お知らせを追加
    label_news_comment_added: お知らせへのコメント追加
    label_display_used_statuses_only: このチケット種別で使用中のステータスのみ表示
    label_roadmap: マイルストーン
    label_in_less_than: n日後、以前
    label_in_more_than: n日後、以降
    label_in: n日後
    label_less_than_ago: n日前、以降
    label_more_than_ago: n日前、以前
    label_ago: n日前
    label_in_the_next_days: 今後n日以内
    label_in_the_past_days: 過去n日以内
    field_tracker: チケット種別
    field_is_in_roadmap: チケットをマイルストーンに表示する
    text_workflow_edit: ワークフローを編集するロールとチケット種別を選んでください
    text_tracker_no_workflow: このチケット種別にワークフローが定義されていません
    text_no_configuration_data: "ロール、チケット種別、チケットのステータス、ワークフローがまだ設定されていません。\nデフォルト設定のロードを強くお勧めします。ロードした後、それを修正することができます。"
    text_issue_added: "チケット %{id} を %{author} が作成しました。"
    text_issue_updated: "チケット %{id} を %{author} が更新しました。"
    text_user_mail_option: "未選択のプロジェクトでは、ウォッチまたは関係している事柄(例: 自分が報告者もしくは担当者であるチケット)のみメールが送信されます。"
    notice_account_lost_email_sent: パスワードの再設定手順をメールで送信しました。
    mail_subject_wiki_content_added: "Wikiページ %{id} の追加"
    mail_body_wiki_content_added: "Wikiページ %{id} を %{author} が追加しました。"
    mail_subject_wiki_content_updated: "Wikiページ %{id} の更新"
    mail_body_wiki_content_updated: "Wikiページ %{id} を %{author} が更新しました。"
    enumeration_doc_categories: ドキュメントカテゴリ
    permission_add_documents: ドキュメントの追加
    permission_edit_documents: ドキュメントの編集
    permission_delete_documents: ドキュメントの削除
    permission_view_documents: ドキュメントの閲覧
    permission_view_news: お知らせの閲覧
    permission_manage_news: お知らせの管理
    permission_comment_news: お知らせへのコメント
    default_doc_category_user: ユーザーマニュアル
    default_doc_category_tech: 仕様書
    default_tracker_bug: 不具合
    default_tracker_feature: 機能
    default_tracker_support: 運用保守
    default_issue_status_new: 未対応
    default_issue_status_in_progress: 対応中
    default_issue_status_resolved: 対応済み
    default_issue_status_feedback: 差し戻し
    default_issue_status_closed: 完了
    default_issue_status_rejected: 却下
    default_priority_low: 低い
    default_priority_normal: 普通
    default_priority_high: 高い
    default_priority_urgent: 緊急
    default_priority_immediate: 至急
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
