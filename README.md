Let's Redmine
==========================

利用方法
-----------------

### 仮想マシンを起動

以下のコマンドを実行し仮想マシンを起動します。

```
vagrant up
```

### Redmineのデモ環境を開く

以下のメッセージが表示されたら、
ブラウザで[http://localhost:8080](http://localhost:8080)を開きます。

```
TASK [Finish display message] **************************************************
ok: [default] => {
    "msg": "Let's Redmine!"
}
```

初期構築時のRedmineのログイン情報は以下の通りです。

| ユーザー名 | パスワード |
| ---------- | ---------- |
| admin      | admin      |

システム構成
-----------------

* Debian 9
* MariaDB
* Nginx

カスタマイズ方法
-----------------

[provision/host_vars/default.yml](provision/host_vars/default.yml)の内容を編集し、  
Redmineのセットアップ内容を変更できます。

設定可能な変数には以下のようなものがあります。


セットアップ後に変数を変更した場合は、
以下のコマンドを実行し変更内容を適用しなおす必要があります。

```
vagrant provision
```

### redmine_version

Redmineのバージョンを指定します。

```yml
redmine_version: "3.4-stable"
```

設定する値はGithubのブランチ名やタグ名を指定します。

* https://github.com/redmine/redmine/branches
* https://github.com/redmine/redmine/releases


### redmine_themes

インストールするテーマを指定します。

```yml
redmine_themes:
  # Githubのリポジトリから取得
  - name: farend_fancy
    repo: "https://github.com/farend/redmine_theme_farend_fancy.git"
    # テーマのディレクトリ名を指定(任意)
    # ディレクトリ名の指定を省略した場合はname属性の値をディレクトリ名として展開します
    # directory: farend_fancy
  - name: farend_basic
    repo: "https://github.com/farend/redmine_theme_farend_basic.git"
  - name: gitmike
    repo: "https://github.com/makotokw/redmine-theme-gitmike.git"
```

### redmine_plugins

インストールするプラグインを指定します。

```yml
redmine_plugins:
  # Githubのリポジトリから取得
  - name: view_customize
    repo: "https://github.com/onozaty/redmine-view-customize.git"
    # プラグインのディレクトリ名を指定(任意)
    # ディレクトリ名の指定を省略した場合はname属性の前に「redmine_」を付与したディレクトリに展開します
    directory: view_customize
  - name: issue_templates
    repo: "https://github.com/akiko-pusu/redmine_issue_templates.git"
  # ファイルをアップロードしてインストールする場合
  - name: easy_gantt
    # ファイルのパスを指定します
    file: path/to/EasyGanttFree.zip
  - name: agile
    file: path/to/redmine_agile-light.zip
  - name: checklists
    file: path/to/redmine_checklists-light.zip
```

### redmine_settings

Redmineの設定を指定します。

```yml
redmine_settings:
  ## -------------
  ## 全般
  ## -------------
  ## アプリケーションのタイトル
  app_title: Redmineデモ環境
  ## ウェルカムメッセージ
  welcome_text: |
    # Redmineのデモ環境
  ## ホスト名とパス
  host_name: localhost:8080
  ## テキスト書式
  text_formatting: markdown
  ## -------------
  ## 表示
  ## -------------
  ## テーマ
  # ui_theme: ""
  ## デフォルトの言語
  default_language: ja
  ## ユーザー名の表示形式
  user_format: lastname_firstname
```

### redmine_customize_language

Redmineの言語設定のカスタマイズ内容を指定します。  
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
```
