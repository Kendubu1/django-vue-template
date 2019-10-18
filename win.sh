#!/bin/bash

cd /home/site/wwwroot
source antenv3.6/bin/activate

echo "START SCRIPT STARTING" 
curl -sL https://deb.nodesource.com/setup_10.x | bash - \
apt-get install -y nodejs
echo "Node Installed"
apt remove cmdtest -y
apt remove yarn -y
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get -y install yarn
yarn install #error
echo "Yarn Installed" 
pip install pipenv
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
pipenv install --dev && pipenv shell

echo "venv setup" 

yarn build
echo "starting..." 

export PORT=8000
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi:application
