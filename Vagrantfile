# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# if we have already clone project just skip this hook
# but the best way is to use vagrant plugins
# we need to get path to Vagrantfile 
# in order not to git clone each time if we are in some other vagrant "subfolder"
system({"VPATH" => File.dirname(__FILE__)}, "if [ ! -d ${VPATH}/fuel-web/.git ] ; then git clone https://github.com/stackforge/fuel-web ${VPATH}/fuel-web;fi")


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu-14.04"

  config.vm.provider "virtualbox" do |v|
        v.memory = 1048
        v.cpus = 1
  end

  config.vm.provision :shell, path: "./.bootstrap/fuel-web_bootstrap.sh"

  config.vm.network :forwarded_port, guest: 80, host: 8081

  config.vm.synced_folder "fuel-web/", "/home/vagrant/fuel-web"
  # we don't need default "sync" folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

end
