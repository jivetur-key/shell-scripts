#!/bin/bash
python aurscrp.py &

cnt=0
while [ $cnt -eq 0 ]; do
    if [ ! -f "paclist.txt" ]; then
		clear && echo "connecting to the aur"
		sleep 5
	else
		echo "complete"
		cnt=1
	fi
done

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
rm paclist.txt

