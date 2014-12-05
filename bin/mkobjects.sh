#!/bin/bash

[[ -a $1 ]] && rm $1 || echo "1st Run..."

git st &> /dev/null

[[ $? != 0 ]] && VCS="svnp" || VCS="git"

cnt=0

for i in $(${VCS} ls {VW,TRG,FN,SP}*); do
	echo -e "Adding \033[01;30m$i\033[00m"
	cat $i >> $1
	echo >> $1
	sleep 0.05
	let cnt++
done 

echo "${cnt} Objects added"
dos2unix $1
# Remove UTF BOM
echo "BOM remove"
sed -i -e 's/^\xEF\xBB\xBF//' $1

echo -e "\033[01;35mDone"

