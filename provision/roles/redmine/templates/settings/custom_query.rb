#{% raw %}
def import_custom_query(queryies)
  queryies.each do |item|
    if item['id'].present?
      custom_query = IssueQuery.find_by_id(item['id'])
    else
      custom_query = IssueQuery.find_by_name_and_project_id(item['name'], nil)
    end
    unless custom_query
      custom_query = IssueQuery.new
      # 表示：全てのユーザー
      custom_query.visibility = 2
      # 全プロジェクト向け
      custom_query.project = nil
      custom_query.user = User.current
    end
    custom_query.name = item['name']
    ## フィルター
    filter_fields = []
    filter_operators = {}
    filter_values = {}
    item['filters'].each do |key, value|
      field_name = key
      field_filter_operator = value['operator'] || value['op']
      field_filter_value = value['values'] || []
      case key
      when 'status'
        field_name = 'status_id'
        field_filter_value = IssueStatus.where(:name => field_filter_value).pluck(:id).map {|item| item.to_s }
      when 'tracker'
        field_name = 'tracker_id'
        field_filter_value = Tracker.where(:name => field_filter_value).pluck(:id).map {|item| item.to_s }
      when 'priority'
        field_name = 'priority_id'
        field_filter_value = IssuePriority.where(:name => field_filter_value).pluck(:id).map {|item| item.to_s }
      when 'author'
        field_name = 'author_id'
        has_me = field_filter_value.include?('me')
        field_filter_value = User.where(:login => field_filter_value).pluck(:id).map {|item| item.to_s }
        field_filter_value.push 'me' if has_me
      when 'assigned_to'
        field_name = 'assigned_to_id'
        has_me = field_filter_value.include?('me')
        field_filter_value = User.where(:login => field_filter_value).pluck(:id).map {|item| item.to_s }
        field_filter_value.push 'me' if has_me
      end
      filter_fields.push field_name
      filter_operators[field_name] = field_filter_operator
      filter_values[field_name] = field_filter_value
    end
    form_params = {}
    ## フィルター
    form_params[:fields] = filter_fields
    form_params[:operators] = filter_operators
    form_params[:values] = filter_values
    ## 表示項目
    form_params[:c] = item['columns'] if item.key?('columns')
    ## 並び順
    if item.key?('sort')
      form_params[:sort] = []
      item['sort'].each do |sort|
        form_params[:sort].push [sort['field'], sort['order']]
      end
    end
    ## グループ条件
    form_params[:group_by] = item['group_by'] if item.key?('group_by')
    ## 合計
    form_params[:t] = item['total'] if item.key?('total')
    custom_query.build_from_params form_params
    custom_query.save
  end
end
queryies = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'custom_query.yml')
queryies = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_custom_query(queryies) if queryies.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
