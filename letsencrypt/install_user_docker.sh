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
echo "** Please, enter the name of the new user to be created, or an exits user to be modified: "
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
echo "** The $nombre user belong to the followin groups:"
groups $nombre
echo -e "\n"
echo -e "\n"

echo -e "***********************************"
echo "  Installing docker in ubuntu ..."
echo -e "***********************************"

apt-get update
echo -e "\n"
echo -e "\n"

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    htop
echo -e "\n"
echo -e "\n"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo -e "\n"
echo -e "\n"

apt-key fingerprint 0EBFCD88
echo -e "\n"
echo -e "\n"

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo -e "\n"
echo -e "\n"

apt-get update
echo -e "\n"
echo -e "\n"

apt-get install docker-ce=17.12.1~ce-0~ubuntu
echo -e "\n"
echo -e "\n"

usermod -a -G docker $nombre
echo "** The $nombre user belong to the follow groups:"
groups $nombre
echo -e "\n"
echo -e "\n"

su - $nombre -c "docker --version"
echo "** docker was installed succesfully"
echo -e "\n"
echo -e "\n"


echo -e "**********************************************************************"
echo "  Installing docker-compose (1.19.0) in ubuntu ..."
echo -e "**********************************************************************"

curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo -e "\n"
echo -e "\n"

su - $nombre -c "docker-compose --version"
echo "** docker-compose was installed succesfully"


echo -e "\n"
echo -e "\n"
echo -e "*******************************************************************************************"
echo "  ¡¡¡¡¡Please, to finish the installation you must exit of this current bash!!!!!"
echo "  After that, you should run the ./install_application.sh with the newly created user ($nombre)"
echo -e "*******************************************************************************************"

exit