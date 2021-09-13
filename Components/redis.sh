#!/bin/bash

source Components/common.sh

Print "Installing yum utils and downloading Redis repos\t\t\t"

yum install epel-release yum-utils yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG
Status_Check $?

Print "Setup Redis repos\t\t\t"

yum-config-manager --enable remi &>>$LOG
Status_Check $?

Print "Install Redis repos\t\t\t\t"

yum install redis -y &>>$LOG
Status_Check $?

Print "Updating Redis IP address\t\t\t"

if [ -f /etc/redis.conf]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>$LOG
fi
if [ -f /etc/redis.redis.conf]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.redis.conf &>>$LOG
fi
Status_Check $?

Print "Start Redis service\t\t"

systemctl enable redis &>>$LOG && systemctl restart redis &>>$LOG
Status_Check $?