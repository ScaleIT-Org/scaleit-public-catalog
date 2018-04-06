#!/bin/bash

programname=$0

function usage {
    echo "usage: $programname [param]"
    echo "   -local      if the programm is local, need no parameter"
    echo "   -remote [link]     if the programm in the remote repository, need a link"
    exit 1
}


if [ "$1" = "" ]; then
  usage
fi


if [ "$1" = "-remote" ] && [ $2 = "" ]; then
  echo Link to the repo
  read $2
fi

function remote {

  name=${1##*/}
  name=${name%.git}

  echo $name

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

  # Create config (only the first creat of the entry).
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
  # Read environments variable from .env.default and parse them to questions in
  # rancher-compose
  cd $name
  echo "version: '2'
  catalog:
    name: \"$name\"
    version: \"$version\"" >> rancher-compose.yml
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
}

function local {

  name=${pwd##*/}

  if [ ! -d "rancher-catalog-entry" ]; then
    mkdir rancher-catalog-entry
  fi

  # Copy the icon
  cp catalogIcon-$name.*  ./rancher-catalog-entry

  # Create config (only the first creat of the entry).
  if [ ! -f "./rancher-catalog-entry/config.yml" ]; then
    echo Creating config.yml
    echo Write description of the App
    read description
    echo "name: $name
    description: |
      $description
    category: Applications" >> ./rancher-catalog-entry/config.yml
  fi


  # Count the folders which names are version numbers and set the new version
  # number.
  version=0
  for f in  ./rancher-catalog-entry/* ; do
    if [ -d $f ]
      then
      f=${f##*/}
      if [ $version -le $f ]
        then version=$((f + 1))
      fi;
    fi;
  done;
  echo Number $version
  mkdir ./rancher-catalog-entry/$version
  # Creating rancher.compose.yml
  # Read environments variable from .env.default and parse them to questions in
  # rancher-compose
  echo "version: '2'
  catalog:
    name: \"$name\"
    version: \"$version\"" >> ./rancher-catalog-entry/$version/rancher-compose.yml
  if [ -f ".env.default" ]; then
    echo "  questions:" >> ./rancher-catalog-entry/rancher-compose.yml
    cat .env | while read line; do
      echo $line
      echo "    - variable: \"${line%=*}\"" >> ./rancher-catalog-entry/rancher-compose.yml
      echo "      default: ${line##*=}" >> ./rancher-catalog-entry/rancher-compose.yml
    done
  fi

  # Move the docker-compose.yml and rancher-compose.yml from cloned repo to the
  # new version folder.
  cp ./docker-compose.yml ./rancher-catalog-entry/$version/docker-compose.yml

  # Change version of docker-compose file to 2 and change App version name in
  # rancher-compose.
  sed -i '' 's/version: .*/version: "2"/g'  ./rancher-catalog-entry/$version/docker-compose.yml
}

if [ "$1" = "-remote" ]; then
  remote $2
elif [ "$1" = "-local" ]; then
  local
else
  usage
fi
