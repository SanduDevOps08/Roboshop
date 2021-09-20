#!/bin/bash

#source Components/common.sh

Status_Check()
{
if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
else
    echo -e "\e[31mFAILURE\e[0m"
exit 2
fi
}


Print()
{
echo -e "\n\t\t\e[36m...................$1...................\e[0m\n"
echo -n -e "$1 \t-"
}


if [ $UID -ne 0 ]; then

   echo -e "\n\e[1;33mYou Should Execute This Script as a Root User\e[0m\n" 
   exit 1
fi   

LOG=/tmp/Roboshop.log
rm -f $LOG


ADD_APP_USER()
{
    
    id Roboshop &>>$LOG
    if [ $? -eq 0]; then
     echo "The user already exists, hence skipping" &>>$LOG
    else 
    useradd -G wheel roboshop &>>$LOG
    fi
    Status_Check $?   
 
}

DOWNLOAD()
{
    Print "Downloading ${COMPONENT} zipfile content\t\t"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
    Status_Check $?  
    Print "Extracting the ${COMPONENT} files"
    cd /home/roboshop
    rm -rf ${COMPONENT} && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && mv user-main ${COMPONENT}
    Status_Check $?
}

systemD.Setup()
{
    Print "Update systemD service"
    
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
    Status_Check $?
    
    Print "Setup systemD service"
    
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG && systemctl daemon-reload && systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
    Status_Check $?
      
}


NODEJS()
{
    source Components/common.sh
    
    Print "Installing nodejs packages\t\t"
    
    yum install nodejs make gcc-c++ -y &>>$LOG
    Status_Check $?
    
    ADD_APP_USER
    DOWNLOAD
    
    Print "Download nodeJS dependencies"
    
    cd /home/roboshop/${COMPONENT} &>>$LOG
    npm install --unsafe-perm &>>$LOG
    Status_Check $?
    chown roboshop:roboshop -R /home/roboshop
    systemD.Setup
        
}


JAVA() 
{
  Print "Installing Maven\t"
  yum install maven -y &>>$LOG
  Status_Check $?
  ADD_APP_USER
  DOWNLOAD
  cd /home/roboshop/shipping
  Print "Make Shipping Package\t"
  mvn clean package &>>$LOG
  Status_Check $?
  Print "Rename Shipping Package"
  mv target/shipping-1.0.jar shipping.jar &>>$LOG
  Status_Check $?
  chown roboshop:roboshop -R /home/roboshop
  SystemdD_Setup
}

PYTHON() 
{
  Print "Install Python3\t\t"
  yum install python36 gcc python3-devel -y &>>$LOG
  Status_Check $?

  ADD_APP_USER

  DOWNLOAD

  cd /home/roboshop/payment
  Print "Install Python Dependencies"
  pip3 install -r requirements.txt &>>$LOG
  Status_Check $?

  USERID=$(id -u roboshop)
  GROUPID=$(id -g roboshop)

  Print "Update RoboShop User in Config"
  sed -i -e "/uid/ c uid=${USERID}" -e "/gid/ c gid=${GROUPID}"  /home/roboshop/payment/payment.ini &>>$LOG
  Status_Check $?

  SystemdD_Setup
}

