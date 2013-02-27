#!/bin/bash
shift # get rid of -c
 
# if no commands, just open a shell
if [[ $# -eq 0 ]]; then
        /bin/bash -l
 
# if the first arg is a git- command, that means it is something like git-push, etc... so forward it
elif [[ $1 == git-* ]]; then
        ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no git@127.0.0.1 $*
 
# if the first arg is SET_ENV_ONLY, we sourced this file in order to set up the gitolite function 
elif [[ $1 == "SET_ENV_ONLY" ]]; then
        gitolite () {
                ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no git@127.0.0.1 $*
        }
 
# if there is at least one non-git command, source this file in a new shell and create the 'gitolite' function
else
        /bin/bash -c "source $0 shiftme SET_ENV_ONLY; $*"
fi
