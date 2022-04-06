#{% raw %}
def import_issue_custom_filed(custom_fileds)
  custom_fileds.each do |item|
    next unless ALLOW_FIELD_FORMTS.include?(item['field_format'])
    cf = IssueCustomField.find_by_name(item['name'])
    cf = IssueCustomField.new unless cf
    import_custom_filed(cf, item)
  end
end

issue_custom_fileds = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'issue_custom_field.yml')
issue_custom_fileds = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_issue_custom_filed(issue_custom_fileds) if issue_custom_fileds.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
