require 'spec_helper'

redmine_home = property['redmine_home']
redmine_mode = property['redmine_mode']

describe file(redmine_home + '/config/puma.rb') do
  it { should exist }
  it { should be_file }

  it { should contain "environment '#{redmine_mode}'" }

  redmine_puma_cfg = property['redmine_puma_cfg']
  it { should contain "bind '#{redmine_puma_cfg['bind']}'" }
  it { should contain "pidfile '#{redmine_puma_cfg['pidfile']}'" }
  it { should contain "state_path '#{redmine_puma_cfg['state_path']}'" }

  redirect_stdout = redmine_puma_cfg['stdout_redirect']['stdout']
  redirect_stderr = redmine_puma_cfg['stdout_redirect']['stderr']
  redirect_appent = redmine_puma_cfg['stdout_redirect']['append'] ? 'true' : 'false'
  it { should contain "stdout_redirect '#{redirect_stdout}', '#{redirect_stderr}', #{redirect_appent}" }

  it { should contain "threads '#{redmine_puma_cfg['threads']['min']}', '#{redmine_puma_cfg['threads']['max']}'" }
  it { should contain "bind '#{redmine_puma_cfg['bind']}'" }
  if redmine_puma_cfg.key?('quiet') && redmine_puma_cfg['quiet']
    it { should contain 'quiet' }
  else
    it { should_not contain 'quiet' }
  end
  it { should contain "workers #{redmine_puma_cfg['workers']}" } if redmine_puma_cfg.key?('workers')
  if redmine_puma_cfg.key?('prune_bundler') && redmine_puma_cfg['prune_bundler']
    it { should contain 'prune_bundler' }
  else
    it { should_not contain 'prune_bundler' }
  end
  if redmine_puma_cfg.key?('preload_app') && redmine_puma_cfg['preload_app']
    it { should contain 'preload_app!' }
  else
    it { should_not contain 'preload_app!' }
  end
end

describe file('/lib/systemd/system/redmine.service') do
  it { should contain "ExecStart=/usr/bin/bundle exec puma -C #{redmine_home}/config/puma.rb -e #{redmine_mode}" }
end
