# カスタムフィールド(ユーザー)
#{% raw %}
def import_user_custom_field(custom_fileds)
  custom_fileds.each do |item|
    next unless ALLOW_FIELD_FORMTS.include?(item['field_format'])
    cf = UserCustomField.find_by_name(item['name'])
    cf = UserCustomField.new unless cf
    import_custom_filed(cf, item)
  end
end

user_custom_fields = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'user_custom_field.yml')
user_custom_fields = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_user_custom_field(user_custom_fields) if user_custom_fields.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
