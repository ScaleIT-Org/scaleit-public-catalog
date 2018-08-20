# Rancher catalog [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
Rancher provides a catalog of application templates that make it easy to deploy these complex stacks. By accessing the Catalog tab, you can view all the templates that are available in the enabled catalogs.

## How to Use
If you want to integrate catalog in your rancher instance, go to **Rancher ADMIN** -> **Settings** and add catalog name and repo link ([https://github.com/ScaleIT-Org/scaleit-public-catalog] for this catalog) like here:

![settings](images/settings.png)

## Entries in catalog
To add or update an app from remote repository start the script **autoload.sh** in root catalog directory with the link to repository as argument:
```
./autoload.sh -remote [link]
```
Or you can run it local from the root directory of your app and then move it to your catalog:
```
./autoload.sh -local
```
If there is no entry with the app, script creates one, else it add the new version. You can also do it manually, just add a folder like this:

![folder_strukture](images/folder_strukture.png)


## Screenshots
![result](images/result.png)
![result1](images/result1.png)

## Requirements

## Features

* Adds apps or creates a new catalog
* Generates questions from environment variables

## Known Issues

  Script reports issue on ubuntu (but works right).

  Not works for docker-compose with builds.

## Troubleshooting

## How to build

### Examples

## Configuration

## Tests

## Notes

Some screenshots are from http://rancher.com/docs/rancher/v1.2/en/catalog/private-catalog/
