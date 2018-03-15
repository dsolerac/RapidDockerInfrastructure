#!/usr/bin/env bash

#
# Install customization
#
#sudo userdel -r genomapp

sudo -s

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

#echo "** The user directory of $nombre is:"
#cd /home/$nombre
#echo $(pwd)

apt-get upgrade

apt install htop


echo -e "\n"
echo -e "\n"
echo -e "***********************************"
echo "Installing docker in ubuntu xenial ..."
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
echo -e "***********************************"
echo "Installing docker-compose (1.19.0) in ubuntu xenial ..."
echo -e "***********************************"


curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

su - $nombre -c "docker-compose --version"
echo "** docker-compose was installed succesfully"


echo -e "\n"
echo -e "\n"
echo -e "***********************************"
echo "Loading environment variables and building the context..."
echo -e "****"

echo "** Current user: " $USER
su - $name
echo "** It has just changed into the new user created, henceforth the installation will continue with: " $USER

######################################################################################
######################################################################################
# So far the base software was installed, henceforth the application will be installed
#
# This file is an adaptation based on the original of evertramos (thanks):
# https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/blob/master/start.sh
######################################################################################
######################################################################################

cd
echo "** Changed into the user directory to download the RapidDockerInfrastructure : " $(pwd)

git clone https://github.com/dsolerac/RapidDockerInfrastructure.git

echo "** Moving files to the root application directory"

#/home/<user>/RapidDockerInfrastructure/letsencrypt
cd RapidDockerInfrastructure/letsencrypt
mkdir ../../letsencrypt
cp ./* ../../letsencrypt
cp ./.env ../../letsencrypt

cd ../../letsencrypt
echo "** Changed into the root application directory to install: " $(pwd)

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else
    echo "Please set up your .env file before starting your enviornment."
    exit 1
fi

# 2. Create docker network
docker network create $NETWORK

# 3. Download the latest version of nginx.tmpl
# IMPORTANT!! To run docker-compose properly, is mandatory that nginx.tmpl file is located in the same directory as it.
# Besides, inside of docker-compose file, the template must be invoked in this way ./nginx.tmpl
#su - $nombre -c "mkdir $APP_ROOT_DIRECTORY_PATH"
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > ./nginx.tmpl

# 4. Update local images
docker-compose pull

# 5. Start proxy
docker-compose up -d
