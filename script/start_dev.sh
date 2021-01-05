#!/bin/zsh

check="✔"
cross="✘"
red="\033[31m"
yellow="\033[33m"
green="\033[32m"
endColor="\033[97m"

# spin up backend
echo -e "${yellow}\tSpinning up rails server${endColor}"
rails s -d -p 3001
if [[ $? -gt 0 ]]; then
    echo -e "${red}\t${cross}Error creating rails server${endColor}"
    exit 1
fi

echo -e "${green}\t${check} API server running on http://localhost:3001${endColor}"
