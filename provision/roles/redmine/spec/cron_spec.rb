require 'spec_helper'

if property['redmine_send_reminders_cron_job']['enabled']
  describe cron do
    hour = minute = '*'
    if property['redmine_send_reminders_cron_job'].key?('minute')
      minute = property['redmine_send_reminders_cron_job']['minute']
    end
    if property['redmine_send_reminders_cron_job'].key?('hour')
      hour = property['redmine_send_reminders_cron_job']['hour']
    end
    job = 'cd ' + property['redmine_home'] + ' && bundle exec rake redmine:send_reminders'
    param = ''
    if property['redmine_send_reminders_cron_job'].key?('params')
      param = property['redmine_send_reminders_cron_job']['params'].join(' ')
    end
    it { should have_entry("#{minute} #{hour} * * * #{job} #{param}").with_user(property['redmine_user']) }
  end
end

if property['redmine_receive_imap_cron_job']['enabled']
  describe cron do
    hour = minute = '*'
    if property['redmine_receive_imap_cron_job'].key?('minute')
      minute = property['redmine_receive_imap_cron_job']['minute']
    end
    hour = property['redmine_receive_imap_cron_job']['hour'] if property['redmine_receive_imap_cron_job'].key?('hour')
    job = 'cd ' + property['redmine_home'] + ' && bundle exec rake redmine:email:receive_imap'
    param = property['redmine_receive_imap_cron_job']['params'].join(' ')
    it { should have_entry("#{minute} #{hour} * * * #{job} #{param}").with_user(property['redmine_user']) }
  end
end

if property['redmine_receive_pop3_cron_job']['enabled']
  describe cron do
    hour = minute = '*'
    if property['redmine_receive_pop3_cron_job'].key?('minute')
      minute = property['redmine_receive_pop3_cron_job']['minute']
    end
    hour = property['redmine_receive_pop3_cron_job']['hour'] if property['redmine_receive_pop3_cron_job'].key?('hour')
    job = 'cd ' + property['redmine_home'] + ' && bundle exec rake redmine:email:receive_pop3'
    param = property['redmine_receive_pop3_cron_job']['params'].join(' ')
    it { should have_entry("#{minute} #{hour} * * * #{job} #{param}").with_user(property['redmine_user']) }
  end
end
