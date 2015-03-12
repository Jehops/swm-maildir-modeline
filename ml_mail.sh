#!/bin/sh

## customize these
## use host=. for local host
host=my_host
path=~/mail/new
port=22
user=me
interval=30

stump_pid=$(pgrep -a -n stumpwm)

## while stumpwm is still running
while kill -0 $stump_pid > /dev/null 2>&1; do
    if [ ${host} = '.' ]; then
	echo $(ls ${path} | wc -l)
    else
	echo $(/usr/bin/ssh -p ${port} -x -o ConnectTimeout=1 ${user}@${host} \
			    "ls ${path} | wc -l")
    fi
    sleep ${interval}
done