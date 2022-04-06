#{% raw %}
def import_issue_templates(settings)
  if Redmine::Plugin.installed? :redmine_issue_templates
    settings.each do |item|
      tracker = Tracker.find_by_name(item['tracker'])
      if item['id'].present?
        template = GlobalIssueTemplate.find_by_id(item['id'])
      else
        template = GlobalIssueTemplate.find_by_tracker_id_and_title(tracker.id, item['name'])
      end
      template = GlobalIssueTemplate.new unless template
      ## トラッカー
      template.tracker_id = tracker.id
      ## テンプレート名
      template.title = item['name']
      ## チケットタイトル
      template.issue_title = item['issue_title'] if item.key?('issue_title')
      ## チケット本文
      template.description = item['description']
      ## デフォルト値
      template.is_default = !!item['is_default'] if item.key?('is_default')
      ## 有効
      template.enabled = !!item['enabled'] if item.key?('enabled')
      ## メモ
      template.note = item['note'] if item.key?('note')
      ## 関連リンク
      template.related_link = item['related_link'] if item.key?('related_link')
      ## 関連リンクのタイトル
      template.link_title = item['link_title'] if item.key?('link_title')
      ## 表示順序
      template.position = item['position'] if item.key?('position')
      template.author = User.current if template.new_record?
      template.save
    end
  end
end
settings = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'issue_template.yml')
settings = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_issue_templates(settings) if settings.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
