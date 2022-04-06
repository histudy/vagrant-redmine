#{% raw %}
def import_message_customize(setting)
  if Redmine::Plugin.installed? :redmine_message_customize
    plugin_setting = CustomMessageSetting.find_or_default
    plugin_setting.update_with_custom_messages_yaml(setting)
  end
end
setting = ''
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'message_customize.yml')
setting = File.read(import_setting_file) if File.exists?(import_setting_file)

import_message_customize(setting) if setting != '{}'
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
