#!/usr/bin/env bash

######################################################################################
######################################################################################
# So far the base software was installed, henceforth the application will be installed
#
# This file is an adaptation based on the original of evertramos (thanks):
# https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/blob/master/start.sh
#
# This script must be executed after execution of install_user_docker.sh file, to leverege the user created for install
# the docker lestencrypt containers. This user (just created) must to be used to execute this script, because this user
# belong to the sudo users group, due to will run a docker-compose file.
#
# Before execute this script file, it is mandatory to configurate the environment variables file (.env) located in user directory.
#
######################################################################################
######################################################################################

echo "** Are you running this script with a properly user, like the user created before (not root)? (yes or no)"
read answer1

if [ "$answer1" == "" ] || ["$answer1" == "no"] || ["$answer1" == "NO"] || ["$answer1" == "No" ]
then
    clear
    echo -e "\n"
    echo "** Please, confirm if the actual running user this script is correct."
    echo -e "\n"
    exit 1
else if ["$answer1" == "yes"] || ["$answer1" == "YES"] || ["$answer1" == "Yes" ]
then
    echo "** ok, continue executing with the $USER user"
fi

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else
    echo "Please set up your ./.env file before starting your enviornment."
    exit 1
fi

echo "** have you customized your ./.env file, properly? (yes or no)"
read answer2

if [ "$answer2" == "" ] || ["$answer2" == "no"] || ["$answer2" == "NO"] || ["$answer2" == "No" ]
then
    clear
    echo -e "\n"
    echo "** Please, customize your environment file (./.env) file properly."
    echo -e "\n"
    exit 1
fi


# 2. Create docker network
docker network create $NETWORK

# 3. Download the latest version of nginx.tmpl
# IMPORTANT!! To run docker-compose properly, is mandatory that nginx.tmpl file is located in the same directory as it.
# Besides, inside of docker-compose file, the template must be invoked in this way ./nginx.tmpl
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > ./nginx.tmpl

# 4. Update local images
docker-compose pull

# 5. Start proxy
docker-compose up -d
