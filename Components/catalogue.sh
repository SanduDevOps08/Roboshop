#!/bin/bash

source Components/common.sh

COMPONENT=catalogue

<<<<<<< HEAD
NODEJS
=======
yum install nodejs make gcc-c++ -y &>>$LOG
Status_Check $?

Print "Adding the Roboshop user"

id roboshop &>>$LOG
if [ $? -eq 0 ]; then
 echo "The user already exists, hence skipping" &>>$LOG
else 
useradd -G wheel roboshop &>>$LOG
fi
Status_Check $?

Print "Downloading Catalogue zipfile content"

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
Status_Check $?

Print "Extracting the Catalogue files"

cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>$LOG && mv catalogue-main catalogue
Status_Check $?

Print "Download nodeJS dependencies"

cd /home/roboshop/catalogue &>>$LOG
npm install --unsafe-perm &>>$LOG
Status_Check $?

Print "Update systemD service"

sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" /home/roboshop/catalogue/systemd.service
Status_Check $?

Print "Setup systemD service"

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG && systemctl daemon-reload && systemctl restart catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
Status_Check $?

exit 0
>>>>>>> 0c227774b00f1ce19f9e8378bb558813633a94d9
