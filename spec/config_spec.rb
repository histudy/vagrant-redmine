require 'spec_helper'

describe file(property['redmine_home'] + '/.bundle/config') do
  it { should exist }
  it { should be_file }
  its(:content) { should match 'BUNDLE_PATH: "vendor/bundle"' }
  its(:content) { should match 'BUNDLE_WITHOUT: "development:test"' }
end

describe file(property['redmine_home'] + '/config/database.yml') do
  it { should exist }
  it { should be_file }
  redmine_db_cfg = property['redmine_db_cfg']['production']
  its(:content) { should match "adapter: #{redmine_db_cfg['adapter']}" }
  its(:content) { should match "host: #{redmine_db_cfg['host']}" }
  its(:content) { should match "database: #{redmine_db_cfg['database']}" }
  its(:content) { should match "username: #{redmine_db_cfg['username']}" }
  its(:content) { should match "password: #{redmine_db_cfg['password']}" }
  its(:content) { should match "encoding: #{redmine_db_cfg['encoding']}" }
end

describe file(property['redmine_home'] + '/config/configuration.yml') do
  it { should exist }
  it { should be_file }
  redmine_cfg = property['redmine_cfg']['default']
  email_delivery = redmine_cfg['email_delivery']
  it { should contain "delivery_method: :#{email_delivery['delivery_method']}" }
  if email_delivery['delivery_method'] == :smtp
    smtp_settings = email_delivery['smtp_settings']
    its(:content) { should match "address: #{smtp_settings['address']}" }
    its(:content) { should match "port: #{smtp_settings['port']}" }
    if smtp_settings.key?('authentication')
      its(:content) { should match "authentication: #{smtp_settings['authentication']}" }
    end
    its(:content) { should match "domain: #{smtp_settings['domain']}" } if smtp_settings.key?('domain')
    its(:content) { should match "user_name: #{smtp_settings['user_name']}" } if smtp_settings.key?('user_name')
    its(:content) { should match "password: #{smtp_settings['password']}" } if smtp_settings.key?('password')
    if smtp_settings.key?('enable_starttls_auto')
      enable_starttls_auto = smtp_settings['authentication'] ? 'true' : 'false'
      its(:content) { should match "enable_starttls_auto: #{enable_starttls_auto}" }
    end
  end
  its(:content) { should match "attachments_storage_path: #{redmine_cfg['attachments_storage_path']}" }
  its(:content) { should match "rmagick_font_path: #{redmine_cfg['rmagick_font_path']}" }
end
