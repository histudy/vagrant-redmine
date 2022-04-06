#{% raw %}
def import_group(groups)
  groups.each do |item|
    if item['id'].present?
      group = Group.find_by_id(item['id'])
      group.name = item['name']
    else
      group = Group.find_by_lastname(item['name'])
    end
    group = Group.new unless group
    group.name = item['name']
    if group.save
      if item['users'].present?
        users = User.where(:login => item['users']).to_a
        group.users = users
        end
    end
  end
end

groups = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'group.yml')
groups = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_group(groups) if groups.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
