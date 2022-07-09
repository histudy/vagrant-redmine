# -*- mode: ruby -*-
# vi: set ft=ruby :

# ENV['VAGRANT_EXPERIMENTAL'] = "disks"
Vagrant.configure("2") do |config|
  config.vm.box = "wate/debian-11"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "private_network", ip: "192.168.56.200"
  config.vm.synced_folder "./", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  config.vm.disk :disk, name: "extra_strage", size: "20GB"

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end

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
