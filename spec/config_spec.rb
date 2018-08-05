require 'spec_helper'

describe file(property['redmine_home'] + '/.bundle/config') do
  it { should exist }
  it { should be_file }
  it { should contain 'BUNDLE_PATH: "vendor/bundle"' }
  it { should contain 'BUNDLE_WITHOUT: "development:test"' }
end

describe file(property['redmine_home'] + '/config/database.yml') do
  it { should exist }
  it { should be_file }
  redmine_db_cfg = property['redmine_db_cfg']['production']
  it { should contain "adapter: #{redmine_db_cfg['adapter']}" }
  it { should contain "host: #{redmine_db_cfg['host']}" }
  it { should contain "database: #{redmine_db_cfg['database']}" }
  it { should contain "username: #{redmine_db_cfg['username']}" }
  it { should contain "password: #{redmine_db_cfg['password']}" }
  it { should contain "encoding: #{redmine_db_cfg['encoding']}" }
end

describe file(property['redmine_home'] + '/config/configuration.yml') do
  it { should exist }
  it { should be_file }
  redmine_cfg = property['redmine_cfg']['default']
  email_delivery = redmine_cfg['email_delivery']
  it { should contain "delivery_method: :#{email_delivery['delivery_method']}" }
  if email_delivery['delivery_method'] == :smtp
    smtp_settings = email_delivery['smtp_settings']
    it { should contain "address: #{smtp_settings['address']}" }
    it { should contain "port: #{smtp_settings['port']}" }
    it { should contain "authentication: #{smtp_settings['authentication']}" } if smtp_settings.key?('authentication')
    it { should contain "domain: #{smtp_settings['domain']}" } if smtp_settings.key?('domain')
    it { should contain "user_name: #{smtp_settings['user_name']}" } if smtp_settings.key?('user_name')
    it { should contain "password: #{smtp_settings['password']}" } if smtp_settings.key?('password')
    if smtp_settings.key?('enable_starttls_auto')
      enable_starttls_auto = smtp_settings['authentication'] ? 'true' : 'false'
      it { should contain "enable_starttls_auto: #{enable_starttls_auto}" }
    end
  end
  it { should contain "attachments_storage_path: #{redmine_cfg['attachments_storage_path']}" }
  it { should contain "rmagick_font_path: #{redmine_cfg['rmagick_font_path']}" }
end
