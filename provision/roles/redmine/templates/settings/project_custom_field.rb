# カスタムフィールド(プロジェクト)
#{% raw %}
def import_project_custom_field(custom_fileds)
  custom_fileds.each do |item|
    next unless ALLOW_FIELD_FORMTS.include?(item['field_format'])
    cf = ProjectCustomField.find_by_name(item['name'])
    cf = ProjectCustomField.new unless cf
    import_custom_filed(cf, item)
  end
end

project_custom_fields = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'project_custom_field.yml')
project_custom_fields = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_project_custom_field(project_custom_fields) if project_custom_fields.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
