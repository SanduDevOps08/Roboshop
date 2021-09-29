#!/bin/bash

source Components/common.sh

Print "Creating the repository\t"

Print '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo &>>$LOG

Print "Installing and starting the service"
yum install -y mongodb-org &>>$LOG
Status_Check $?


Print "Configuring the Mongodb\t"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
Status_Check $?


Print "starting mongodb\t"
systemctl enable mongod
systemctl restart mongod &>>$LOG
Status_Check $?


Print "Downloading schema\t"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
Status_Check $?


Print "Extracting the zip files\t"
cd /tmp
unzip -o mongodb.zip &>>$LOG
Status_Check $?


cd mongodb-main

Print "Loading Schema\t\t"
for schema in catalogue users ; do
  mongo < $schema.js &>>$LOG
done
Status_Check $?

