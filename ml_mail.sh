#!/bin/sh

## customize these
## use host=. for local host
ap="/usr/local/bin/mpg123"
nms="${HOME}/files/media/audio/chime.mp3"
count=0
host=.
newcount=0
path=~/mail/new
port=22
user=me
interval=10

# Set the variable stump_pid using one of these two lines.  Which line you use
# depends on whether you run the large StumpWM executable that bundles SBCL, or
# if you simply start SBCL and load StumpWM.  If you are using the FreeBSD
# StumpWM package, use the second line.

#stump_pid="$(pgrep -a -n stumpwm)"
stump_pid="$(pgrep -anf -U "$(id -u)" "sbcl .*(stumpwm:stumpwm)")"

## while stumpwm is still running
while kill -0 "$stump_pid" > /dev/null 2>&1; do
    if [ "$host" = '.' ]; then
	newcount="$(ls ${path} | wc -l | tr -d '[:space:]')"
    else
	newcount=$(/usr/bin/ssh -p "$port" -x -o ConnectTimeout=1
		   "$user"@"$host" "ls $path | wc -l | tr -d '[:space:]'")
    fi
    [ "$newcount" -gt "$count" ] && "$ap" "$nms" > /dev/null 2>&1
    count="$newcount"
    echo "$count"
    sleep "$interval"
done