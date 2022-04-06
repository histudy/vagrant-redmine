#{% raw %}
def import_workflow(workflows)
  all_statuses = IssueStatus.all
  workflows.each do |item|
    roles = Role.where(:name =>  item['roles']).to_a
    trackers = Tracker.where(:name =>  item['trackers']).to_a

    transitions = {}
    status_ids = all_statuses.pluck(:id).map {|item| item.to_s }
    status_ids.prepend '0'
    status_ids.each do |status_id|
      all_statuses.each do |status|
        transitions[status_id] = {} unless transitions.key?(status_id)
        transitions[status_id][status.id.to_s] = {'always' => false, 'author' => false, 'assignee' => false}
      end
    end
    item['transitions'].each do |transition|
      from_status_id = '0'
      if transition['from']
        from_status = IssueStatus.find_by_name(transition['from'])
        from_status_id = from_status.id.to_s
      end
      to_statuses = IssueStatus.where(:name => transition['to'])
      to_statuses.each do |to_status|
        to_status_id = to_status.id.to_s
        transitions[from_status_id][to_status_id]['always'] = true
      end
    end
    WorkflowTransition.replace_transitions(trackers, roles, transitions)
  end
end

workflows = [];
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'workflow.yml')
workflows = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_workflow(workflows) if workflows.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
