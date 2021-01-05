#!/bin/zsh

check="✔"
green="\033[32m"
yellow="\033[33m"
endColor="\033[97m"

if [[ -f 'tmp/pids/server.pid' ]]; then
    echo -e "${yellow}\tShutting down cashflow rails server${endColor}"
    # if the rails server is running kill it
    kill $(cat tmp/pids/server.pid)
fi

echo -e "${green}\t${check} API server shut down${endColor}"
