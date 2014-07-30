#!/bin/bash

source="/home/git/repositories/"
destination="/mnt/hgfs/Repositories/git"

logfile="git2host-$(date +%Y-%m-%d).log"
logpath="/var/log/backup"
log="${logpath}/${logfile}"

echo "$(date +%Y/%m/%d\ %H:%M:%S) Starting backup..." >> ${log}

rsync -rLt --delete --log-file=${log} ${source} ${destination}

echo -e "$(date +%Y/%m/%d\ %H:%M:%S) End of backup\n\n" >> ${log}

