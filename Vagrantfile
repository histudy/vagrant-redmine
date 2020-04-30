# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "histudy/stretch"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.200"
  config.vm.synced_folder "./", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "shell", path: "provision/install_ansible.sh"
  ansible_extra_vars = {}
  extra_var_file = File.expand_path(File.join(File.dirname(__FILE__), 'extra_vars.yml'))
  if File.exists?(extra_var_file)
    ansible_extra_vars = YAML.load_file(extra_var_file)
  end
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end

  # vagrant-execプラグインの設定
  if Vagrant.has_plugin?('vagrant-exec')
    vagrant_exec_env = {
      'RAILS_ENV' => ansible_extra_vars['redmine_mode'] || 'production'
    }
    config.exec.commands '*', directory: '/opt/redmine', env: vagrant_exec_env
    config.exec.commands %w[rails rake], prepend: 'bundle exec', directory: '/opt/redmine', env: vagrant_exec_env
    config.exec.commands 'systemctl', prepend: 'sudo'
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.become = true
    ansible.compatibility_mode = "2.0"
    ansible.provisioning_path = "/vagrant/provision"
    ansible.playbook = "playbook.yml"
    ansible.config_file = "/vagrant/provision/ansible.cfg"
    ansible.extra_vars = ansible_extra_vars
  end
end
