#!/usr/bin/env bash

######################################################################################
######################################################################################
# This script make easy the docker and docker-compose installation and the user
# creation for the application.
# This script must be executed the first with root privileges and when it finishes,
# the install_application.sh file must be executed with user created here.
######################################################################################
######################################################################################

echo -e "\n"
echo -e "\n"
echo -e "***********************************"
echo "Creating application user ..."
echo -e "***********************************"

if [ $(id -u) != 0 ] ; then
echo -e "\n"
echo $(id -u)
echo "** Having root permissions is mandatory to run the next tasks"
exit 1
fi

echo -e "\n"
echo -e "\n"
echo "** Please, enter the name of the new user to be created: "
read nombre

if [ "$nombre" == "" ] ; then
clear
echo -e "\n"
echo "** The name cannot be empty"
echo -e "\n"
exit 1
fi

adduser $nombre
usermod -aG sudo $nombre

echo -e "\n"
echo -e "\n"
echo "** The $nombre user belong to the follow groups:"
groups $nombre


apt-get upgrade
apt install htop

echo -e "\n"
echo -e "\n"
echo -e "***********************************"
echo "  Installing docker in ubuntu xenial ..."
echo -e "***********************************"

sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list"

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys

apt-get install docker-engine

apt-get update

usermod -aG docker $nombre

su - $nombre -c "docker --version"
echo "** docker was installed succesfully"


echo -e "\n"
echo -e "\n"
echo -e "**********************************************************************"
echo "  Installing docker-compose (1.19.0) in ubuntu xenial ..."
echo -e "**********************************************************************"


curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

su - $nombre -c "docker-compose --version"
echo "** docker-compose was installed succesfully"


echo -e "\n"
echo -e "\n"
echo -e "*******************************************************************************************"
echo "  Please after that, run the ./install_application.sh with the newly created user ($nombre)"
echo -e "*******************************************************************************************"