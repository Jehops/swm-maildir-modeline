#!/bin/sh

## customize these variables
host=gly ## use . for local host
path=~/mail/new
port=44422
ssh=/usr/bin/ssh
user=jrm

interval=30
if [ ${host} = '.' ]; then
    nmc="ls ${path} | wc -l"
else
    nmc="${ssh} -p ${port} -x -o ConnectTimeout=1 ${user}@gly 'ls ${path} | wc -l'"
fi
stump_pid=`pgrep -a -n stumpwm`

# while stumpwm is still running
while kill -0 $stump_pid > /dev/null 2>&1; do
    nm=`eval ${nmc}`
    echo $nm
    sleep ${interval}
done