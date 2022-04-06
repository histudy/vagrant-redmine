#{% raw %}
def import_workflow_permission(workflow_permissions)
  all_statuses = IssueStatus.all
  status_ids = all_statuses.pluck(:id).map {|item| item.to_s }
  permission_fields = {
    'project' => {
      'name' => 'project_id',
      'values' =>['readonly']
    },
    'tracker' => {
      'name' => 'tracker_id',
      'values' =>['readonly']
    },
    'subject' => {
      'values' => ['readonly']
    },
    'description' => {
      'values' => ['readonly', 'required']
    },
    'priority' => {
      'name' => 'priority_id',
      'values' => ['readonly']
    },
    'assigned_to' => {
      'name' => 'assigned_to_id',
      'values' => ['readonly', 'required']
    },
    'category' => {
      'name' => 'category_id',
      'values' => ['readonly', 'required']
    },
    'fixed_version' => {
      'name' =>'fixed_version_id',
      'values' => ['readonly', 'required']
    },
    'parent_issue' => {
      'name' => 'parent_issue_id',
      'values' => ['readonly', 'required']
    },
    'start_date' => {
      'values' => ['readonly', 'required']
    },
    'due_date' => {
      'values' => ['readonly', 'required']
    },
    'estimated_hours' => {
      'values' => ['readonly', 'required']
    },
    'done_ratio' => {
      'values' => ['readonly', 'required']
    },
    'is_private' => {
      'values' => ['readonly', 'required']
    }
  }
  workflow_permissions.each do |item|
    roles = Role.where(:'name' => item['roles'])
    trackers = Tracker.where(:'name' => item['trackers'])
    permissions = {}
    status_ids.each do |status_id|
      permissions[status_id] = {} unless permissions.key?(status_id)
      permission_fields.each do |key, value|
        field_name = value['name'] || key
        permissions[status_id][field_name] = 'no_change'
      end
    end
    core_fields = permission_fields.keys
    item['permissions'].each do |setting|
      update_fields = setting['fields']
      update_fields = [update_fields] unless update_fields.is_a?(Array)
      custom_field_names = update_fields.reject {|field| core_fields.include?(field) }
      if custom_field_names.present?
        custom_fields = IssueCustomField.where(:name => custom_field_names)
      end
      update_status_ids = IssueStatus.where(:'name' => setting['statuses']).pluck(:id).map { |item| item.to_s }
      update_status_ids.each do |update_status_id|
        update_fields.each do |update_field|
          field_name = update_field
          if permission_fields.key?(field_name)
            field_name = permission_fields[field_name]['name'] if permission_fields[field_name].key?('name')
            permissions[update_status_id][field_name] = setting['permission']
          end
          if custom_fields.present?
            custom_fields.each do |cf|
              permissions[update_status_id][cf.id] = setting['permission']
            end
          end
        end
      end
    end
    permissions.each do |field, rule_by_status_id|
      rule_by_status_id.reject! {|status_id, rule| rule == 'no_change'}
    end
    WorkflowPermission.replace_permissions(trackers, roles, permissions)
  end
end

workflow_permissions = [];
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'workflow_permission.yml')
workflow_permissions = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_workflow_permission(workflow_permissions) if workflow_permissions.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
