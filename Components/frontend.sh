i#!/bin/bash

source Components/common.sh


Print "Installing and starting the nginx service\t\t"

yum install nginx -y &>>$LOG
Status_Check $?

Print "Downloading frontend archives\t\t"

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
Status_Check $?

Print "Extracting the frontend archives\t\t"

rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip && mv frontend-main/* . && mv static html &>>$LOG
Status_Check $?

Print "Copy nginx Roboshop config file\t\t"

mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
Status_Check $?

Print "Update Roboshop config file\t\t"
<<<<<<< HEAD
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf  &>>$LOG
=======
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' -e '/user/s/localhost/user.roboshop.internal/' -e '/cart/s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG
>>>>>>> ebf716d50af94fc5ff06ef9ac3a2ef6b41cbc94b
Status_Check $?

Print "Restart nginx service\t\t"
systemctl enable nginx && systemctl restart nginx &>>$LOG
Status_Check $?
