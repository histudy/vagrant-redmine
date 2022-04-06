#{% raw %}
def import_project(projects)
  # 親プロジェクトがないプロジェクトを登録
  not_has_parent_projects = projects.reject {|item| item['parent'].present? }
  not_has_parent_projects.each do |item|
    project = Project.find_by_identifier(item['identifier'])
    unless project
      project = Project.new
      project.identifier = item['identifier']
    end
    # 名称
    project.name = item['name']
    # 説明
    project.description = item['description'] if item.key?('description')
    # ホームページ
    project.homepage = item['homepage'] if item.key?('homepage')
    # 公開
    project.is_public = item['is_public'] if item.key?('is_public')
    # モジュール
    project.enabled_module_names = item['modules'] if item.key?('modules')
    # トラッカー
    if item.key?('trackers')
      project.tracker_ids = Tracker.where(:name => item['trackers']).pluck(:id)
    end
    # カスタムフィールド
    if item.key?('custom_fields')
      custom_field_values = {}
      item['custom_fields'].each do |custom_field|
        if custom_field['id'].present?
          cf = ProjectCustomField.find_by_id(custom_field['id'])
        else
          cf = ProjectCustomField.find_by_name(custom_field['name'])
        end
        custom_field_values[cf.id] = custom_field['value'] if cf
      end
      project.custom_field_values = custom_field_values
    end
    if project.save
      if item.key?('members')
        project.delete_all_members
        project_members = []
        item['members'].each do |member|
          user = User.find_by_login(member['login'])
          role_ids = Role.where(:name => member['role']).pluck(:id)
          if user && role_ids.present?
            project_member = Member.new(:project => project, :user_id => user.id)
            project_member.role_ids = role_ids
            project_member.save
          end
        end
      end
      if item.key?('wiki_start_page')
        project.wiki.start_page = item['wiki_start_page']
        project.wiki.save
      end
      if item.key?('wiki_pages')
        import_project_wiki_pages project, item['wiki_pages']
      end
    end
  end
  # 親プロジェクトがあるプロジェクトを登録
  has_parent_projects = projects.select {|item| item['parent'].present? }
  has_parent_projects.each do |item|
    project = Project.find_by_identifier(item['identifier'])
    unless project
      project = Project.new
      project.identifier = item['identifier']
    end
    # 名称
    project.name = item['name']
    # 説明
    project.description = item['description'] if item.key?('description')
    # ホームページ
    project.homepage = item['homepage'] if item.key?('homepage')
    # 公開
    project.is_public = !!item['is_public'] if item.key?('is_public')
    # メンバーを継承
    project.inherit_members = !!item['inherit_members'] if item.key?('inherit_members')
    # モジュール
    project.enabled_module_names = item['modules'] if item.key?('modules')
    # トラッカー
    if item.key?('trackers')
      project.tracker_ids = Tracker.where(:name => item['trackers']).pluck(:id)
    end
    # カスタムフィールド
    if item.key?('custom_fields')
      custom_field_values = {}
      item['custom_fields'].each do |custom_field|
        if custom_field['id'].present?
          cf = ProjectCustomField.find_by_id(custom_field['id'])
        else
          cf = ProjectCustomField.find_by_name(custom_field['name'])
        end
        custom_field_values[cf.id] = custom_field['value'] if cf
      end
      project.custom_field_values = custom_field_values
    end
    if project.save
      parent = Project.where("identifier = :parent OR name = :parent", {parent: item['parent']}).sorted.first
      project.set_parent! parent if parent
      if item.key?('members')
        project.delete_all_members
        project_members = []
        item['members'].each do |member|
          user = User.find_by_login(member['login'])
          role_ids = Role.where(:name => member['role']).pluck(:id)
          if user && role_ids.present?
            project_member = Member.new(:project => project, :user_id => user.id)
            project_member.role_ids = role_ids
            project_member.save
          end
        end
      end
      if item.key?('wiki_start_page')
        project.wiki.start_page = item['wiki_start_page']
        project.wiki.save
      end
      if item.key?('wiki_pages')
        import_project_wiki_pages project, item['wiki_pages']
      end
    end
  end
end

def import_project_wiki_pages(project, wiki_pages)
  wiki_pages.each do |wiki_page|
    page = project.wiki.find_or_new_page wiki_page['name']
    content = page.content || WikiContent.new(:page => page)
    content.text = wiki_page['content']
    content.author = User.current
    page.save_with_content(content)
  end

  has_parent_wiki_pages = wiki_pages.select {|item| item['parent'].present? }
  has_parent_wiki_pages.each do |wiki_page|
    page = project.wiki.find_or_new_page wiki_page['name']
    page.parent_title = wiki_page['parent']
    page.save
  end
end

projects = []
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'project.yml')
projects = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_project(projects) if projects.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
