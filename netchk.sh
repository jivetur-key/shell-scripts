#!/bin/bash
# checks to make sure netctl connected to my wifi and if not restarts the service
# requires libnotify 
# For creating a shorthand of the netctl command
shopt -s expand_aliases 
alias util='sudo netctl'
# obtains the the profile name
entry=$(util list | sed 's/\*//;s/ //')
# allows the DE to do it's thing
sleep 30
# function to check the wifi status with hidden output
check (){
    util is-active ${entry} &> /dev/null
}
# checks the connection and reconnects if necessary with a five attempt limit
# success or failure is displayed as a desktop notification
for i in {1..5}
do
    if check ; then
	notify-send "Connection Established to '${entry}'" --icon=network-transmit-receive
	break
    else
	util restart ${entry}
    fi
done
# final check after the five attempts
if ! check ; then
    notify-send "Connection failed : maxium attempts reached at ${entry}" --icon=network-error
else
    exit
fi

