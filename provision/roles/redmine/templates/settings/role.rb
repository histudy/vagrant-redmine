#{% raw %}
def import_role(roles)
  roles.each do |item|
    if item['id'].present?
      role = Role.find_by_id(item['id'])
      role.name = item['name']
    else
      role = Role.find_by_name(item['name'])
    end
    is_new = false
    unless role
      role = Role.new
      is_new = true
      role.name = item['name']
      role.assignable = true
      role.issues_visibility = 'default'
      role.users_visibility = 'all'
      role.time_entries_visibility = 'all'
    end
    # このロールにチケットを割り当て可能
    role.assignable = item['assignable'] if item.key?('assignable')
    # 表示できるチケット
    role.issues_visibility = item['issues_visibility'] if item.key?('assignable')
    # 表示できるユーザー
    role.users_visibility = item['users_visibility'] if item.key?('assignable')
    # 表示できる作業時間
    if item.key?('time_entries_visibility')
      role.time_entries_visibility = item['time_entries_visibility']
    end
    # 権限
    role.permissions = item['permissions'] if item.key?('permissions')
    # 権限(追加)
    if item.key?('append_permissions')
      role_permissions = role.permissions
      role_permissions.concat item['append_permissions']
      role.permissions = role_permissions
    end
    # メンバーの管理
    role.all_roles_managed = '1'
    role.managed_role_ids = []
    if item.key?('managed_roles') && item['permissions'].include?('manage_members')
      role.all_roles_managed = '0'
      role.managed_role_ids = Role.where(:name => item['managed_roles']).pluck(:id)
    end

    permissions_all_trackers = {
      'view_issues' => '1',
      'add_issues' => '1',
      'edit_issues' => '1',
      'add_issue_notes' => '1',
      'delete_issues' => '1'
    }
    permissions_tracker_ids = {
      'view_issues' => [],
      'add_issues' => [],
      'edit_issues' => [],
      'add_issue_notes' => [],
      'delete_issues' => []
    }
    if item.key?('permissions_trackers')
      permissions_trackers = item['permissions_trackers']
      if permissions_trackers.key?('view_issues')
        view_issue_tracker_ids = Tracker.where(:name => permissions_trackers['view_issues']).pluck(:id)
        permissions_tracker_ids['view_issues'] = view_issue_tracker_ids.map {|item| item.to_s }
        permissions_all_trackers['view_issues'] = '0'
      end
      if permissions_trackers.key?('add_issues')
        add_issue_tracker_ids = Tracker.where(:name => permissions_trackers['add_issues']).pluck(:id)
        permissions_tracker_ids['add_issues'] = add_issue_tracker_ids.map {|item| item.to_s }
        permissions_all_trackers['add_issues'] = '0'
      end
      if permissions_trackers.key?('edit_issues')
        edit_issue_tracker_ids = Tracker.where(:name => permissions_trackers['edit_issues']).pluck(:id)
        permissions_tracker_ids['edit_issues'] = edit_issue_tracker_ids.map {|item| item.to_s }
        permissions_all_trackers['edit_issues'] = '0'
      end
      if permissions_trackers.key?('add_issue_notes')
        add_issue_note_tracker_ids = Tracker.where(:name => permissions_trackers['add_issue_notes']).pluck(:id)
        permissions_tracker_ids['add_issue_notes'] = add_issue_note_tracker_ids.map {|item| item.to_s }
        permissions_all_trackers['add_issue_notes'] = '0'
      end
      if permissions_trackers.key?('delete_issues')
        delete_issue_tracker_ids = Tracker.where(:name => permissions_trackers['delete_issues']).pluck(:id)
        permissions_tracker_ids['delete_issues'] = delete_issue_tracker_ids.map {|item| item.to_s }
        permissions_all_trackers['delete_issues'] = '0'
      end
    end
    role.permissions_all_trackers = permissions_all_trackers
    role.permissions_tracker_ids = permissions_tracker_ids
    # 並び順
    role.position = item['position'] if item.key?('position')
    role.save
    # ワークフローのコピー(新規登録時のみ)
    if is_new && item.key?('copy_workflow_from')
      copy_from = Role.find_by_name(item['copy_workflow_from'])
      role.copy_workflow_rules(copy_from) if copy_from
    end
  end
end

roles = [];
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'role.yml')
roles = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_role(roles) if roles.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
