#!/bin/bash

source Components/common.sh

Print "Installing nodejs packages\t\t"

yum install nodejs make gcc-c++ -y &>>$LOG
Status_Check $?

Print "Adding the Roboshop suser"

useradd -G wheel roboshop &>>$LOG
Status_Check $?

Print "Downloading Catalogue zipfile content"

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
Status_Check $?

cd /home/roboshop

Print "Extracting the Catalogue files"

unzip -o /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
Status_Check $?

Print "Changing to catalogue directory"

cd /home/roboshop/catalogue &>>$LOG
Status_Check $?

npm install 
Status_Check $?

Print "Moving the file from system.service to Catologue.service"

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG
Status_Check $?

systemctl daemon-reload &>>$LOG
Status_Check $?

systemctl start catalogue &>>$LOG
Status_Check $?

systemctl enable catalogue
Status_Check $?

exit 0
