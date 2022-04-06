#{% raw %}
def import_attachment(attachments)
  attachments.each do |item|
    project = Project.find_by_identifier(item['project'])
    project = Project.find_by_name(item['project']) unless project
    project = Project.find_by_id(item['project']) unless project
    if project
      container = project
      if item.key?('wiki')
        wiki = project.wiki.find_or_new_page item['wiki']
        container = wiki
      end
      attachment = Attachment.new(:container => container, :author => User.current)
      attach_file = File.open(item['remote_file'])
      attachment.file = attach_file
      attachment.filename = item['base_file_name']
      attachment.filename = item['file_name'] if item.key?('file_name')
      attachment.description = item['description'] if item.key?('description')
      attachment.save
    end
  end
end

attachments = [];
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'attachment.yml')
attachments = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_attachment(attachments) if attachments.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
