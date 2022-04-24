#{% raw %}
def import_custom_filed(cf, setting)
  allow_length_formats = ['string', 'text', 'link', 'int', 'float']
  allow_regexp_formats = ['string', 'text', 'link', 'int', 'float']
  allow_default_value_formats = ['string', 'text', 'link', 'int', 'float', 'date', 'bool']
  allow_text_formatting_formats = ['string', 'text']
  allow_url_pattern_formats = ['string', 'link', 'date', 'int', 'float', 'list', 'bool']
  allow_edit_tag_style_formats = ['version', 'user', 'list', 'bool', 'enumeration']
  allow_multiple_formats = ['version', 'user', 'list', 'enumeration']
  allow_searchable_formats = ['string', 'text', 'list']

  # 形式
  cf.field_format = setting['field_format']
  # 名称
  cf.name = setting['name']
  # 説明
  cf.description = setting['description'] if setting.key?('description')
  # 必須
  cf.is_required = !!setting['is_required'] if setting.key?('is_required')
  # 最小値または最小文字列長
  if setting.key?('min_length') && allow_length_formats.include?(setting['field_format'])
    cf.min_length = setting['min_length'].to_s
  end
  # 最大値値または最小文字列長
  if setting.key?('max_length') && allow_length_formats.include?(setting['field_format'])
    cf.max_length = setting['max_length'].to_s
  end
  # 正規表現
  cf.regexp = setting['regexp'] if setting.key?('field_format') && allow_regexp_formats.include?(setting['field_format'])
  # 初期値
  if setting.key?('default_value') && allow_default_value_formats.include?(setting['field_format'])
    cf.default_value = setting['default_value'].to_s
  end
  # テキスト書式
  if setting.key?('text_formatting') && allow_text_formatting_formats.include?(setting['field_format'])
    cf.text_formatting = setting['text_formatting'] ? true : false
  end
  # 値に設定するリンクURL
  if setting.key?('url_pattern') && allow_url_pattern_formats.include?(setting['field_format'])
    cf.url_pattern = setting['url_pattern']
  end
  # 表示(入力形式)
  if setting.key?('edit_tag_style') && allow_edit_tag_style_formats.include?(setting['field_format'])
    edit_tag_style = nil
    edit_tag_style = setting['edit_tag_style'] if ['check_box', 'radio'].include?(setting['edit_tag_style'])
    cf.edit_tag_style = edit_tag_style
  end
  # 複数選択
  if setting.key?('multiple') && allow_multiple_formats.include?(setting['field_format'])
    cf.multiple = setting['multiple'] ? true : false
  end
  # 検索対象
  if setting.key?('searchable') && allow_searchable_formats.include?(setting['field_format'])
    cf.searchable = setting['searchable'] ? true : false
  end
  # 選択肢
  if setting.key?('possible_values') && setting['field_format'] == 'list'
    cf.possible_values = setting['possible_values']
  end
  # ロール
  if setting.key?('user_role') && setting['field_format'] == 'user'
    cf.user_role = Role.where(:name => setting['user_role']).pluck(:id).map {|v| v.to_s }
  end
  # ステータス
  if setting.key?('version_status') && setting['field_format'] == 'version'
    cf.version_status = setting['version_status'].select { |v| ['open', 'locked', 'closed'].include?(v) }
  end
  # 許可する拡張子
  if setting.key?('extensions_allowed') && setting['field_format'] == 'attachment'
    extensions_allowed = setting['extensions_allowed']
    extensions_allowed = setting['extensions_allowed'].join(',') if setting['extensions_allowed'].is_a?(Array)
    cf.extensions_allowed = extensions_allowed
  end
  # フィルタとして使用
  if setting.key?('is_filter') && setting['field_format'] != 'attachment'
    cf.is_filter = setting['is_filter'] ? true : false
  end
  # 表示
  if setting.key?('visible')
    unless cf.is_a?(UserCustomField)
      if setting['visible'].is_a?(Array)
        cf.role_ids = Role.where(:name => setting['visible']).pluck(:id).map {|v| v.to_s }
        cf.visible = false
      else
        cf.visible = !!setting['visible']
      end
    else
      cf.visible = !!setting['visible']
    end
  end

  # 表示順序
  cf.position = setting['position'] if setting['position'].present?

  if cf.is_a?(UserCustomField)
    # ユーザーカスタムフィールドの固有処理
    # 編集可能
    cf.editable = true
    if setting.key?('editable')
      cf.visible = !!setting['editable']
    end
  end
  if cf.is_a?(IssueCustomField)
    # チケットカスタムフィールドの固有処理
    # トラッカー
    if setting.key?('trackers')
      cf.tracker_ids = Tracker.where(:name => setting['trackers']).pluck(:id).map {|v| v.to_s }
    end
    # プロジェクト
    cf.is_for_all = true
    if setting.key?('projects')
      cf.is_for_all = false
      cf.project_ids = Tracker.where(:name => setting['projects']).pluck(:id).map {|v| v.to_s }
    end
  end
  cf.save
end
#{% endraw %}
