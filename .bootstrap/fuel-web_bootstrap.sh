#!/bin/bash -x

# We are not using virtualenv as this box is completly for fuel-web project
# share-folder

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y
sudo apt-get install git -y

sudo chown vagrant.vagrant -R /home/vagrant/

# install packages for building docs
sudo apt-get install python-pip python-dev make postgresql postgresql-server-dev-all libyaml-dev nginx-light -y

# we need to upgrade pip and setuptools
sudo pip install pip --upgrade

# there is some issue during upgrade to the latest version of setuptools, we need to remove apt packages
# and use pip only
sudo apt-get remove python-setuptools -y
hash -r
# and install setuptools from pip
sudo pip install setuptools

# Installing java
PLATINUM_LOCATION="/usr/local/bin/plantuml.jar"
sudo apt-get install openjdk-7-jre -y
# Installing platinuml.jar, we can skip this step, because Makefile download it in any way
# but let's keep it for future
sudo wget http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O "${PLATINUM_LOCATION}"
sudo chown vagrant.vagrant "${PLATINUM_LOCATION}"
chmod +x "${PLATINUM_LOCATION}"

# installing depend. packages
cd /home/vagrant/fuel-web && sudo pip install ./shotgun
cd /home/vagrant/fuel-web && sudo pip install -r nailgun/test-requirements.txt

# fixing permissions
sudo chown vagrant.vagrant -R /home/vagrant/

####################### configuring nginx
NGINX_USER=$(grep user /etc/nginx/nginx.conf | cut -d' ' -f2 | cut -d';' -f1)
sudo usermod ${NGINX_USER} -a -G vagrant

# One worker is enough
# grep worker_processes /etc/nginx/nginx.conf | sed 's/[0-9]\+/1/g'
sudo sed -i 's/worker_processes [0-9]\+/worker_processes 1/g' /etc/nginx/nginx.conf

# we can also change BUILD folder, but in the example below we store
# detault values for make
sudo bash -c 'cat << EOF > /etc/nginx/sites-available/fuel-web.conf
server {
        listen   80;

        root /home/vagrant/fuel-web/docs/_build/html;
        index index.html index.htm;

        # Make site accessible from http://localhost/
        server_name localhost;

        # the default location is for fuel-web project
        location / {
                try_files \$uri \$uri/ /index.html;
        }

	# location for pdf files
	location /pdf/ {
		alias /home/vagrant/fuel-web/docs/_build/pdf/;
	}

}
EOF'

sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/fuel-web.conf /etc/nginx/sites-enabled/fuel-web.conf

if ! sudo nginx -t >/dev/null ; then
	echo "Nginx has some error in it's configuration"
	exit 1
fi

sudo service nginx restart
######### end of nginx configuration

## building html and pdf
cd /home/vagrant/fuel-web/docs && make html
cd /home/vagrant/fuel-web/docs && make pdf

# clear screen before info
clear
echo "You can access documents using http://localhost:8081"
echo "Your git project is on your host in ./fuel-web"
