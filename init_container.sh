#!/bin/sh
echo "Starting SSH..."
/usr/sbin/sshd

echo "Template Setup"
yarn install
python --version

echo "Venv Setup"
#### 
pipenv install --dev --skip-lock /bin/activate
pipenv --where
pipenv --venv
echo "pip shell"
$(pipenv --venv)/bin/activate
pipenv shell
####

python manage.py migrate

echo "Starting Dev Server + Gunicorn..."
yarn build
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi:application


