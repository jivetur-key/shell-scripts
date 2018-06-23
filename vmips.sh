# Shell script to find ip addresses of running kvm machines
# Requires Nmap
#!/bin/bash
# create a shorthand alias for output editing
shopt -s expand_aliases
alias txtcut="sed '1,2d;$d' | tr -s ' ' "
# Command pipeline to extract mac address by name from domiflist command each address is stored in array
get_macks () {
    macks[$1]=$(virsh domiflist $2 | txtcut | cut -d ' ' -f 5)
}
# Command pipeline to extract ip from nmap based on mac. Each address is stored in an array
get_ipadd () {
    ipadd[$1]=$(nmap -sP 10.0.0.0/24 | grep -i $2 -B 3 | sed -n '2p' | cut -d ' ' -f 5)
}
# print loop to display result arrays with a header on first iteration
display_results () {

    if [ $1 -eq 0 ]
    then
	printf "%s %s\n" $(( SIZE + 1 )) "hypervisors running"
    fi 

    printf "%s\t%s\t%s\n" ${names[$1]} ${ipadd[$1]} ${macks[$1]}
}
# Takes functions as arguments to populate arrays or display them
main_loop () {

    if [ "$#" -ne "1" ]
    then
	declare -a locarr=( "${!2}" )
    fi

    for i in $(eval echo "{0..$SIZE}")
    do
	$1 $i ${locarr[$i]}
    done
}
# array of kvm machine names from virsh command pipeline
names=( $(virsh list --state-running | txtcut | cut -d ' ' -f 3) )
# check if any machine is running
if [ -z "$names" ]
then
    echo -e "no hypervisors running\n"
    exit
fi
# variable for main loop's for loops range
SIZE=$(( ${#names[@]}-1 ))
# names array and get mack function is passed and will populate array of mack addresses
main_loop get_macks names[@]
# mack address and function is passed will populate array of ip addresses
main_loop get_ipadd macks[@]
# Print to the array to output
main_loop display_results 
