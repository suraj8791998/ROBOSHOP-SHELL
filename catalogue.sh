#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "SETTING NODEJS VENDOR" 

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "INSTALLING NODEJS" 

USER=$(id roboshop)

if [ $USER -ne 0 ]

then

    echo -e "$R USER NOT FOUND, LET'S CREATE A USER ROBOSHOP $N"  

    useradd roboshop &>>$LOGFILE

else
   
   echo -e "$G USER ALREADY EXISTS $N"

fi

mkdir /app


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app &>>$LOGFILE

VALIDATE $? "MOVING INTO APPLICATION"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "UNZIPPING THE APPLICATION"

npm install  &>>$LOGFILE

VALIDATE $? "INSTALLING DEPENDENCIES"

cp /home/centos/ROBOSHOP-SHELL/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "COPYING THE SERVICE"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "RELOADING THE SERVICE"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "ENABLING THE CATALOGUE"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "STARTING CATALOGUE"

cp /home/centos/ROBOSHOP-SHELL/mongo.repo  /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "COPYING MONGO-REPO"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "INSTALLING MONGO-REPO CLIENT"

mongo --host 172.31.88.38 < /app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "LOADING THE SCHEMEA"