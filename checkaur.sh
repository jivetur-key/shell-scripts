#!/bin/bash
# check aur repo for updates
# requires python web scraper script
python aurscrp.py &
sleep 15
# creates two arrays one from a file the other using pacman to display all packages installed from the aur
auray=( $(cat paclist.txt) )
myray=( $(pacman -Qm | cut -d ' ' -f 1))
declare -a update
c=0
for i in ${myray[@]}
do
    for j in ${auray[@]}
    do
	if [ "$i" == "$j" ]
	then
	    update[$c]=$i
	    (($c+1))
	fi
    done
done
printf "The following updates are available\n"
echo ${update[@]}
