#!/bin/bash

echo "Installing nodejs packages"

yum install nodejs make gcc-c++ -y 

echo "Adding the user"

useradd -G wheel roboshop

echo "Downloading zipfile"

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop

echo "Unarchiving the zipfile"

unzip /tmp/catalogue.zip
mv catalogue-main catalogue

echo "Changing to catalogue directory"
cd /home/roboshop/catalogue
npm install 

echo "Moving the file from system.service to Catologue.service"

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue

echo "Execution completed"
