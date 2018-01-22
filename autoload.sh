#!/bin/bash 
echo Creating new version ${1##*/} App in catalog
cd ${1##*/}


echo Cloning $1
git clone $1
cd ${1##*/}

log=$(git log -1 --pretty --oneline)
log=${log##* }
cd ..
echo App version $log

version=0

for f in  ./* ; do
  if [ -d $f ]
    then
    f=${f##*/}
    if [ $version -le $f ]
      then version=$((f + 1))
    fi;
  fi;
done;
echo Number $version

cp -r ./$((version-1)) ./$version

mv ./${1##*/}/docker-compose.yml ./$version/docker-compose.yml
rm -rf ./${1##*/}

cd ./$version
sed -i '' 's/version: .*/version: "2"/g'  docker-compose.yml
sed -i '' 's/ version: .*/ version: "'$log'"/g'  rancher-compose.yml
