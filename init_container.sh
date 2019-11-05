#!/bin/sh
echo "Starting SSH..."
/usr/sbin/sshd

echo "Setting Up Template"
yarn install
pipenv install --dev && pipenv shell
python manage.py migrate

echo "Starting Dev Server + Gunicorn..."
yarn build
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi:application
