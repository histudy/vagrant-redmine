require 'spec_helper'

property['redmine_plugins'].each do |plugin|
  dir_name = 'redmine_' + plugin['name']
  dir_name = plugin['directory'] if plugin.key?('directory')
  describe file(property['redmine_home'] + '/plugins/' + dir_name) do
    it { should exist }
    it { should be_directory }
  end
  if plugin.key?('cron')
    describe cron do
      minute = plugin['cron']['minute'] || '*'
      hour = plugin['cron']['hour'] || '*'
      day = plugin['cron']['day'] || '*'
      month = plugin['cron']['month'] || '*'
      job = 'cd ' + property['redmine_home'] + ' && ' + plugin['cron']['command']
      it { should have_entry("#{minute} #{hour} #{day} #{month} * #{job}").with_user(property['redmine_user']) }
    end
  end
  next unless plugin.key?('required_packages')
  plugin['required_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end
