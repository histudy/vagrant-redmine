#{% raw %}
def import_setting(setting)
  redmine_setting = setting.reject {|key, value| key.start_with?('plugin_') }
  if redmine_setting.key?('default_projects_trackers')
    redmine_setting['default_projects_tracker_ids'] = Tracker.where(:name => redmine_setting['default_projects_trackers']).pluck(:id).map {|item| item.to_s }
    redmine_setting.delete('default_projects_trackers')
  end
  if redmine_setting.present?
    Setting.set_all_from_params(redmine_setting)
  end
  plugin_settings = setting.select {|key, value| key.start_with?('plugin_') }
  if plugin_settings.present?
    plugin_settings.each do |plugin_name, plugin_setting|
      if Redmine::Plugin.installed? plugin_name.sub('plugin_', '').to_s
        Setting.send plugin_name + '=', plugin_setting.with_indifferent_access
      end
    end
  end
end

setting = {};
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'setting.yml')
setting = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_setting(setting) if setting.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
