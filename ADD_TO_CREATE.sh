#!/bin/sh

for i in $(ls -1 VW* && ls -1 FN* && ls -1 SP* && ls -1 TRG*)
do
	cat $i | sed -e 's/\xEF\xBB\xBF//' >> CREATE.sql
	echo -e "\n\n" >> CREATE.sql
done

echo -e "Done\n"

