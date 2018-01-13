#!/bin/bash
# simple script for updating packases from the aur
# assumes that there is a builds directory in the users home
# requires git

# creates a list from packages not installed from arch linux repos
list=( $(pacman -Qm | cut -d ' ' -f 1) )
# uses a select loop to create menu from the list
PS3="Pick a package:"
select n in ${list[@]}; do
    name=${list[(( $REPLY - 1 ))]}
    break
done
# enters the builds and clones the package and performs the installation
cd $HOME/builds
git clone --quiet https://aur.archlinux.org/${name}.git > /dev/null
cd ${name} && echo "y" | makepkg -scri &> /dev/null
cd $HOME/builds && rm -rf ${name}
