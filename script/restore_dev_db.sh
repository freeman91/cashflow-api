#!/bin/zsh

# run this in dev when you want to get the latest db snapshot from jupiter

red="\033[31m"
yellow="\033[33m"
green="\033[32m"
endColor="\033[97m"
check="✔"
cross="✘"

DB="cashflow_development"
date=$(date +%Y%m%d)

echo -e "${yellow}\tShutting down cashflow servers${endColor}"
# kill the front end server
servePID=$(ps -c | grep node | xargs)
servePID=$(echo $servePID | egrep -o "^[0-9]*\s")
kill -9 $(echo $servePID)

# kill the backend server
kill -9 $(cat tmp/pids/server.pid)

echo -en "\t${yellow}=> Retrieving production db snapshot:\n${endColor}"
ssh admin@192.168.2.42 'bash -s' << 'ENDSSH'
scp postgres/backups/cashflow_jupiter_$(date +%Y%m%d).bak addisonfreeman@192.168.2.20:/tmp/
ENDSSH

# Check to see if backup file was created
if [[ -f '/tmp/cashflow_jupiter_'$(date +%Y%m%d)'.bak' ]]; then
    echo -e "\t${green}=>cashflow jupiter backup fetched${endColor}"
else
  echo -e "${red}\t${cross} Error fetching latest jupiter backup${endColor}"
    exit 1
fi

# check to see if the dev db exists
psql -lqt | cut -d \| -f 1 | grep -qw $DB

# if dev db does exits, drop it
if [[ $? -eq 0 ]]; then
    echo -e "\t${yellow}=> Dropping CashCode development database:${endColor}"
    dropdb $DB
    if [[ $? -gt 0 ]]; then
        echo -en ""
        echo -e "${red}\t${cross} ERROR dropping the database: check db connections${endColor}"
        exit 1
    fi
fi

# recreate db
echo -e "\t${yellow}=> Recreating CashCode development database:${endColor}"
createdb $DB
if [[ $? -gt 0 ]]; then
    echo -e "${red}\t${cross}Error creating the database${endColor}"
    exit 1
fi

psql -d cashflow_development -U addisonfreeman < /tmp/cashflow_jupiter_$(date +%Y%m%d).bak

if [ $? -gt 0 ]; then
    echo -e "${red}\t${cross} database restore failed${endColor}"
    exit 1
else
    echo -e "${green}\t${check} cashflow_development db restored from jupiter snapshot${endColor}"
fi
