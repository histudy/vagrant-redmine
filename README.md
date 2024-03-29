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
| admin      | password   |

システム構成
-----------------

* Debian 11
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
redmine_version: "4.2-stable"
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
  - name: PurpleMine2
    repo: https://github.com/mrliptontea/PurpleMine2.git
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
  - name: message_customize
    repo: https://github.com/ishikawa999/redmine_message_customize.git
    # プラグインインストール後に行う処理を設定できます
    post_install_action: |
      ln -sf {{ redmine_home }}/plugins/redmine_message_customize/35_change_load_order_locales.rb {{ redmine_home }}/config/initializers/35_change_load_order_locales.rb
  - name: issues_panel
    repo: https://github.com/redmica/redmine_issues_panel.git
  - name: issue_templates
    repo: https://github.com/agileware-jp/redmine_issue_templates.git
  # ファイルをアップロードしてインストールする場合
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
