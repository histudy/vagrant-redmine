#{% raw %}
def import_status(statuses)
  statuses.each do |item|
    if item['id'].present?
      status = IssueStatus.find_by_id(item['id'])
      status.name = item['name']
    else
      status = IssueStatus.find_by_name(item['name'])
    end
    status = IssueStatus.new unless status
    status.safe_attributes = item
    status.position = item['position'] if item['position'].present?
    status.save
  end
end

statuses = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'status.yml')
statuses = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_status(statuses) if statuses.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
