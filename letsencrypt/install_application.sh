#!/usr/bin/env bash

######################################################################################
######################################################################################
# So far the base software was installed, henceforth the application will be installed
#
# This file is an adaptation based on the original of evertramos (thanks):
# https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/blob/master/start.sh
#
# This script must be executed after execution of install_user_docker.sh file, to leverege the user created for install
# the docker lestencrypt containers. This user must to be used to execute this script, because this user belong to the
# sudo users group, due to will run a docker-compose file.
#
######################################################################################
######################################################################################

cd
echo "** Changed into the user directory (which will do the installation) to download the RapidDockerInfrastructure : " $(pwd)

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
