#{% raw %}
def import_tracker(trackers)
  default_issue_status = IssueStatus.first
  # ワークフローのコピー元の指定がないトラッカーを登録
  import_trackers = trackers.reject {|item| item['copy_workflow_from'].present? }
  import_trackers.each do |item|
    if item['id'].present?
      tracker = Tracker.find_by_id(item['id'])
      tracker.name = item['name']
    else
      tracker = Tracker.find_by_name(item['name'])
    end
    unless tracker
      tracker = Tracker.new
      tracker.name = item['name']
      tracker.core_fields = [
        'assigned_to_id',
        'category_id',
        'fixed_version_id',
        'parent_issue_id',
        'start_date',
        'due_date',
        'estimated_hours',
        'done_ratio',
        'description'
      ]
    end
    tracker.core_fields = item['core_fields'] if item['core_fields'].present?
    tracker.default_status_id = default_issue_status.id
    if item['default_status'].present?
      issue_status = IssueStatus.find_by_name(item['default_status'])
      tracker.default_status_id = issue_status.id
    end
    tracker.position = item['position'] if item['position'].present?
    tracker.save
  end

  # ワークフローのコピー元の指定があるトラッカーを登録
  import_trackers = trackers.select {|item| item['copy_workflow_from'].present? }
  import_trackers.each do |item|
    if item['id'].present?
      tracker = Tracker.find_by_id(item['id'])
      tracker.name = item['name']
    else
      tracker = Tracker.find_by_name(item['name'])
    end
    unless tracker
      tracker = Tracker.new
      tracker.name = item['name']
      tracker.core_fields = [
        'assigned_to_id',
        'category_id',
        'fixed_version_id',
        'parent_issue_id',
        'start_date',
        'due_date',
        'estimated_hours',
        'done_ratio',
        'description'
      ]
    end
    tracker.core_fields = item['core_fields'] if item['core_fields'].present?
    tracker.default_status_id = default_issue_status.id
    if item['default_status'].present?
      issue_status = IssueStatus.find_by_name(item['default_status'])
      tracker.default_status_id = issue_status.id
    end
    tracker.position = item['position'] if item['position'].present?
    if tracker.save
      copy_from = Tracker.find_by_name(item['copy_workflow_from'])
      tracker.copy_workflow_rules(copy_from) if copy_from
    end
  end
end
trackers = [];
import_setting_file = File.join(REDMINE_IMPORT_FILE_DIR, 'tracker.yml')
trackers = YAML.load_file(import_setting_file) if File.exists?(import_setting_file)

import_tracker(trackers) if trackers.present?
File.delete(import_setting_file) if File.exists?(import_setting_file)
#{% endraw %}
