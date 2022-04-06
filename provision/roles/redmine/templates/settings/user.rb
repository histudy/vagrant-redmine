#{% raw %}
def import_user(users)
  # メール通知の設定値一覧
  allow_mail_notification_values = [
    # 参加しているプロジェクトのすべての通知
    'selected',
    # ウォッチ中または自分が関係しているもの
    'only_my_events',
    # ウォッチ中または自分が担当しているもの
    'only_assigned',
    # ウォッチ中または自分が作成したもの
    'only_owner',
    # 通知しない
    'none'
  ]
  # コメントの表示順の設定値一覧
  allow_comments_sorting_values = [
    # 古い順
    'asc',
    # 新しい順
    'desc'
  ]
  # テキストエリアのフォントの設定値一覧
  allow_textarea_font_values = [
    # 等幅
    'monospace',
    # プロポーショナル
    'proportional'
  ]

  users.each do |item|
    next unless item.key?('login')
    user = User.find_by_login(item['login'])
    if user
      next if user.id == 1
      # 既存ユーザー情報の更新
      user.firstname = item['firstname'] if item.key?('firstname')
      user.lastname = item['lastname'] if item.key?('lastname')
      user.mail = item['mail'] if item.key?('mail')
      if item.key?('password') && item['password'].present?
        user.password = item['password']
        user.password_confirmation = item['password']
      end
    else
      # ユーザーの新規登録
      user = User.new(:language => Setting.default_language, :mail_notification => Setting.default_notification_option)
      user.login = item['login']
      # 名
      user.firstname = item['firstname']
      # 姓
      user.lastname = item['lastname']
      # メールアドレス
      user.mail = item['mail']
      user.generate_password = true
      if item.key?('password') && item['password'].present?
        user.password = item['password']
        user.password_confirmation = item['password']
        user.generate_password = false
      end
    end
    # 言語
    user.language = item['language'] if item.key?('language')
    # システム管理者
    user.admin = !!item['system_admin'] if item.key?('system_admin') && user.id != 1
    # 次回ログイン時にパスワード変更を強制
    user.must_change_passwd = !!item['must_change_passwd'] if item.key?('must_change_passwd')
    # メール通知
    if item.key?('mail_notification') && allow_mail_notification_values.include?(item['mail_notification'])
      user.mail_notification = item['mail_notification']
    end
    # 自分自身による変更の通知は不要
    user.pref.no_self_notified = !!item['no_self_notified'] if item.key?('no_self_notified')
    # メールアドレスを隠す
    user.pref.hide_mail = !!item['hide_mail'] if item.key?('hide_mail')
    # コメントの表示順
    if item.key?('comments_sorting') && allow_comments_sorting_values.include?(item['comments_sorting'])
      user.pref.comments_sorting = item['comments_sorting']
    end
    # データを保存せずにページから移動するときに警告
    user.pref.warn_on_leaving_unsaved = !!item['warn_on_leaving_unsaved'] if item.key?('warn_on_leaving_unsaved')
    # テキストエリアのフォント
    if item.key?('textarea_font') && allow_textarea_font_values.include?(item['textarea_font'])
      user.pref.textarea_font = item['textarea_font']
    end
    # カスタムフィールド
    if item.key?('custom_fields')
      custom_field_values = {}
      item['custom_fields'].each do |custom_field|
        if custom_field['id'].present?
          cf = UserCustomField.find_by_id(custom_field['id'])
        else
          cf = UserCustomField.find_by_name(custom_field['name'])
        end
        custom_field_values[cf.id] = custom_field['value'] if cf
      end
      user.custom_field_values = custom_field_values
    end
    if item.key?('locked')
      user.status = item['locked'] ? User::STATUS_LOCKED : User::STATUS_ACTIVE
    end
    user.save
  end
end

users = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'user.yml')
users = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_user(users) if users.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
