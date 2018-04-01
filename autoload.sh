#!/bin/bash

name=${1##*/}

if [ ! -d "templates/$name" ]; then
  echo App $name does not exist
  echo Creating $name template
  mkdir templates/$name
fi

# Go to folder with the App.
echo Creating new version $name App in catalog
cd templates/$name

# Cloning the repository with the App.
echo Cloning $1
git clone $1

# Copy the icon
mv $name/catalogIcon-$name.*  .

if [ ! -f "config.yml" ]; then
  echo Creating config.yml
  echo Write description of the App
  read description
  echo "name: $name
  description: |
    $description
  category: Applications" >> config.yml
fi

# Count the folders which names are version numbers and set the new version
# number.
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
mkdir $version
# Creating rancher.compose.yml
echo "version: '2'
catalog:
  name: \"$name\"
  version: \"$version\"" >> ./$version/rancher-compose.yml

# Read environments variable from .env.default and parse them to questions in
# rancher-compose
cd $name
if [ -f ".env.default" ]; then
  echo "  questions:" >> rancher-compose.yml
  cat .env | while read line; do
    echo $line
    echo "    - variable: \"${line%=*}\"" >> rancher-compose.yml
    echo "      default: ${line##*=}" >> rancher-compose.yml
  done
fi
cd ..

# Move the docker-compose.yml and rancher-compose.yml from cloned repo to the
# new version folder.
mv ./$name/docker-compose.yml ./$version/docker-compose.yml
mv ./$name/rancher-compose.yml ./$version/rancher-compose.yml
# Remove the cloned repo.
rm -rf ./$name

# Change version of docker-compose file to 2 and change App version name in
# rancher-compose.
cd ./$version
sed -i '' 's/version: .*/version: "2"/g'  docker-compose.yml
sed -i '' 's/ version: .*/ version: "'$version'"/g'  rancher-compose.yml
