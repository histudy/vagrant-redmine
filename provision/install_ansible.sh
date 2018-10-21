#!/bin/sh
if [ ! -f /usr/bin/dirmngr ]; then
  apt-get install -y dirmngr
fi
if [ ! -f /etc/apt/sources.list.d/ansible.list ]; then
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main">/etc/apt/sources.list.d/ansible.list
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
  apt-get update
fi
if [ ! -f /usr/bin/ansible ]; then
  apt-get install -y ansible
fi
