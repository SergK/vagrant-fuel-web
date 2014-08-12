## Vagrant provision for [fuel-web](https://github.com/stackforge/fuel-web) project

### Description

Use Vagrant to deploy and provision ubuntu VM with [fuel-web](https://github.com/stackforge/fuel-web) environment

Used and tested on:
```
Distributor ID: Ubuntu
Description:    Ubuntu 12.04.5 LTS
Release:        12.04
Codename:       precise
```

### Usage

1. vagrant and virtualbox should be already installed
2. we use our personal template for vagrant ubuntu-12-04-x64, you can build your own or download from [vagrant boxes site](http://www.vagrantbox.es/)
3. `git clone https://github.com/SergK/vagrant-fuel-web.git`
4. `cd vagrant-fuel-web`
    - you can edit file `Vagrantfile` if you need to forward some ports or change virtual machine parameters
5. `vagrant up`
6. open [http://localhost:8081](http://localhost:8081)
7. You can work with project which is in `./fuel-web` (we leave git repository on the host node. This helps us to use the same git configurations as on the host node: _username, aliases, etc_ )
8. To build project use: `./build.sh` 

`Usage: ./build.sh { help | html | singlehtml | pdf | latextpdf | epub }`

That's all

You can use `vagrant ssh` to enter the shell of box

#### More information

Actually we clone project on the host system and not on the VM, this ensures us for using the same git configuration (global) options that are defined for user in the host system (_username, aliases, etc_ ).

_- So why do we need vagrant separate box? We can use **virtualenv**_

_- Actually: **YES**. But what if:_

_1. Your host machine is running on Windows_

_2. You are using CentOS or (RHEL), of course you can install all the necessary using yum_

_3. You don't want to install some libSOMETING-dev in your system or any other packages that we need to build the project and python packages_

_**4. You want to install project with "one click"**_

_5. ..._


