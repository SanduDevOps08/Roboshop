#!/bin/bash

echo "Creating the repository"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo

echo "Installing and starting the service"

yum install -y mongodb-org 

echo "Configuring the Mongodb"

sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mogod.conf

echo "starting mongodb"

systemctl enable mongod
systemctl start mongod

echo "Downloading schema"

curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp

echo "Extracting the zip files"
unzip mongodb.zip
cd mongodb-main

echo "Loading the schema"

mongo < catalogue.js
mongo < users.js 

echo "Restarting mongodb"

systemctl start mongo

echo "Execution completed"