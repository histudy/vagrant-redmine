# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "histudy/stretch"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  config.vm.provision "shell", path: "provision/install_ansible.sh"

  config.vm.provision "ansible_local" do |ansible|
    ansible.become = true
    # ansible.install = false
    ansible.compatibility_mode = "2.0"
    ansible.provisioning_path = "/vagrant/provision"
    ansible.playbook = "playbook.yml"
    ansible.config_file = "/vagrant/provision/ansible.cfg"
  end
end
