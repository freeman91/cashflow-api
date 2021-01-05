#!/bin/zsh

# Run this script on juptiter when you want to deploy the newest release

check="✔"
cross="✘"
red="\033[31m"
yellow="\033[33m"
green="\033[32m"
endColor="\033[97m"

zsh script/kill_server.sh
if [[ $? -gt 0 ]]; then
    echo -e "${red}\t${cross}Error killing the servers${endColor}"
    exit 1
fi

echo -e "${yellow}Fetching and building latest cashflow-api repo${endColor}"
# update local repo from origin master
git pull origin master
if [[ $? -gt 0 ]]; then
    echo -e "${red}\t${cross}Error pulling remote tree${endColor}"
    exit 1
fi

echo -e "${green}\t${check}latest master fetched${endColor}"

# spin up backend
echo -e "${yellow}Spinning up rails server${endColor}"
rails s -d -p 3001 --binding=0.0.0.0
if [[ $? -gt 0 ]]; then
    echo -e "${red}\t${cross}Error creating rails server${endColor}"
    exit 1
fi

echo -e "${green}cashflow successfully deployed to jupiter${endColor}"
