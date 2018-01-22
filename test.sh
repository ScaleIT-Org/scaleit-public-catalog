# ./autoload.sh ${1}
name=templates/${1##*/}
cd name
# Validate the configuration of docker-compose.yml file.
DCONFIG=$(docker-compose -f docker-compose.yml config -q)
if [ -z $DCONFIG ]
then
	echo Docker compose syntax ... OK
else echo Docker compose syntax ... ERROR: NOT CORRECT
fi
# Test if an image exists.
if [ ! $(ls -1A catalogIcon-${1##*/}.* 2>/dev/null | wc -l) -gt 0 ] then
    echo Icon file for app store ... ERROR: NOT FOUND
else echo Icon file for app store ... OK
fi
