#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGSFILE=$LOGSDIR/$0-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

USERID=$(id -u)

if [ $USERID -ne 0 ]

then 
  echo -e "$R ERROR:: PLEASE SWITCH TO THE ROOT USER $N"
  exit 1

fi

VALIDATE(){
    
    if [ $? -ne 0 ]
    
    then
       echo -e "$2 $R FAILURE $N"
       exit 1
    
    else
       echo -e "$2 $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGSFILE
VALIDATE $? "COPYING MONGO REPO TO OUR YUM.REPO"

yum install mongodb-org -y &>>LOGSFILE
VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>>LOGSFILE
VALIDATE $? "ENABLING MONGODB"

systemctl start mongod &>>LOGSFILE
VALIDATE $? "STARTING MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>LOGSFILE
VALIDATE $? "EDITED MONGODB CONFIGURATION"

systemctl restart mongod &>>LOGSFILE
VALIDATE $? "RESTARTED MONGODB SERVICE"
