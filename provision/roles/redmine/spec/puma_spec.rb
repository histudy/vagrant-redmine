require 'spec_helper'

redmine_home = property['redmine_home']
redmine_mode = property['redmine_mode']

describe file(redmine_home + '/config/puma.rb') do
  it { should exist }
  it { should be_file }

  its(:content) { should match "environment '#{redmine_mode}'" }

  redmine_puma_cfg = property['redmine_puma_cfg']

  its(:content) { should match "bind '#{redmine_puma_cfg['bind']}'" }
  its(:content) { should match "pidfile '#{redmine_puma_cfg['pidfile']}'" }
  its(:content) { should match "state_path '#{redmine_puma_cfg['state_path']}'" }

  redirect_stdout = redmine_puma_cfg['stdout_redirect']['stdout']
  redirect_stderr = redmine_puma_cfg['stdout_redirect']['stderr']
  redirect_appent = redmine_puma_cfg['stdout_redirect']['append'] ? 'true' : 'false'
  its(:content) { should match "stdout_redirect '#{redirect_stdout}', '#{redirect_stderr}', #{redirect_appent}" }
  thread_min = redmine_puma_cfg['threads']['min']
  thread_max = redmine_puma_cfg['threads']['max']
  its(:content) { should match "threads '#{thread_min}', '#{thread_max}'" }
  its(:content) { should match "bind '#{redmine_puma_cfg['bind']}'" }
  if redmine_puma_cfg.key?('quiet') && redmine_puma_cfg['quiet']
    its(:content) { should match 'quiet' }
  else
    its(:content) { should_not match 'quiet' }
  end
  it { should contain "workers #{redmine_puma_cfg['workers']}" } if redmine_puma_cfg.key?('workers')
  if redmine_puma_cfg.key?('prune_bundler') && redmine_puma_cfg['prune_bundler']
    its(:content) { should match 'prune_bundler' }
  else
    its(:content) { should_not match 'prune_bundler' }
  end
  if redmine_puma_cfg.key?('preload_app') && redmine_puma_cfg['preload_app']
    its(:content) { should match 'preload_app!' }
  else
    its(:content) { should_not match 'preload_app!' }
  end
end

describe file('/lib/systemd/system/redmine.service') do
  exec_start_cmd = "ExecStart=/usr/bin/bundle exec puma -C #{redmine_home}/config/puma.rb -e #{redmine_mode}"
  its(:content) { should match exec_start_cmd }
end
