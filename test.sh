#!/bin/bash

# ./autoload.sh ${1}
name=${1##*/}
cd templates/name

# Validate the configuration of docker-compose.yml file.
DCONFIG=$(docker-compose config -q)
if [ -z $DCONFIG ]
then
	echo Docker compose syntax ... OK
else echo Docker compose syntax ... ERROR: NOT CORRECT
fi

# Test if an image exists.
if [ ! $(ls -1A catalogIcon-$name.* 2>/dev/null | wc -l) -gt 0 ] then
    echo Icon file for app store ... WARNING: NOT FOUND
else echo Icon file for app store ... OK
fi
