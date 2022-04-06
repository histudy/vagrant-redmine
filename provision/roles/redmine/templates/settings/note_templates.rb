#{% raw %}
def import_note_templates(settings)
  if Redmine::Plugin.installed? :redmine_issue_templates
    settings.each do |item|
      tracker = Tracker.find_by_name(item['tracker'])
      if item['id'].present?
        template = GlobalNoteTemplate.find_by_id(item['id'])
      else
        template = GlobalNoteTemplate.find_by_tracker_id_and_name(tracker.id, item['name'])
      end
      template = GlobalNoteTemplate.new unless template
      ## トラッカー
      template.tracker_id = tracker.id
      ## テンプレート名
      template.name = item['name']
      ## コメント
      template.description = item['description']
      ## 有効
      template.enabled = !!item['enabled'] if item.key?('enabled')
      ## メモ
      template.memo = item['memo'] if item.key?('memo')
      ## 表示するロール
      if item.key?('roles')
        template.visibility = 1
        template.role_ids = Role.where(:name =>  item['roles']).pluck(:id)
      else
        template.visibility = 2  if template.new_record?
      end
      ## 表示位置
      template.position = item['position'] if item.key?('position')
      template.author = User.current if template.new_record?
      template.save
    end
  end
end
settings = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'note_template.yml')
settings = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_note_templates(settings) if settings.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
