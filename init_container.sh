#!/bin/sh
echo "Starting SSH..."
/usr/sbin/sshd
echo "Starting Gunicorn..."
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi:application
