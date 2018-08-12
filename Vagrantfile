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

  if Vagrant.has_plugin?('vagrant-exec')
    config.exec.commands 'rails', prepend: 'bundle exec', directory: '/opt/redmine'
  end

  config.vm.provision "shell", path: "provision/install_ansible.sh"
  ansible_extra_vars = {}
  extra_var_file = File.expand_path(File.join(File.dirname(__FILE__), 'extra_vars.yml'))
  if File.exists?(extra_var_file)
    ansible_extra_vars = YAML.load_file(extra_var_file)
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
