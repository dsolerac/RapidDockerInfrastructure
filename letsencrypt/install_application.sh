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
# Before execute this script file, it is mandatory to configurate the environment variables file (.env) located in
# user directory.
#
######################################################################################
######################################################################################

echo "** Are you running this script with a properly user, like the user created before (not root)? [y/n]"
read answer1

if ["$answer1" == "n"]; then
    clear
    echo -e "\n"
    echo "** Please, confirm if the actual running user this script is correct."
    echo -e "\n"
    exit 1
fi

clear
echo "** ok, continue executing with the $USER user..."
echo "** The $USER user belong to the follow groups:"
groups $USER
echo -e "\n"
echo -e "\n"


# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else
    echo "Please set up your ./.env file before starting your enviornment."
    exit 1
fi

echo "** have you customized your ./.env file, properly? [y/n]"
read answer2

if ["$answer2" == "n"]; then
    clear
    echo -e "\n"
    echo "** Please, customize your environment file (./.env) file properly."
    echo -e "\n"
    exit 1
fi

clear
echo "** ok, continue executing the script..."
echo -e "\n"
echo -e "\n"


# 2. Create docker network
docker network create $NETWORK
echo "** Docker network $NETWORK has been created..."
echo -e "\n"
echo -e "\n"

# 3. Download the latest version of nginx.tmpl
# IMPORTANT!! To run docker-compose properly, is mandatory that nginx.tmpl file is located in the same directory as it.
# Besides, inside of docker-compose file, the template must be invoked in this way ./nginx.tmpl
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > ./nginx.tmpl
echo "** nginx.tmpl templete has been downloaded in $(pwd) directory"
echo -e "\n"
echo -e "\n"

# 4. Update local images
docker-compose pull
echo "** All docker images have been downloaded"
echo -e "\n"
echo -e "\n"

# 5. Start proxy
docker-compose up -d
echo "** Every container have been created, and all of them are running"
echo -e "\n"
echo -e "\n"