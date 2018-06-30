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
```

### redmine_lang

Redmineの初期登録データの言語を指定します。

```yml
redmine_lang: ja
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

redmineの言語設定のカスタマイズ内容を指定します。  
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
    default_tracker_feature: 機能追加
    default_tracker_support: 保守
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
