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

VALIDATE $? "SETTING UP NODEJS"

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

mkdir /app &>>$LOGFILE

VALIDATE $? "CREATING FOLDER"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app  &>>$LOGFILE

VALIDATE $? "MOVING INTO THE APPLICATION"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "UNZIPPING THE APPLICATION"

npm install  &>>$LOGFILE

VALIDATE $? "INSTALLING THE DEPENDENCIES"

cp /home/centos/ROBOSHOP-SHELL/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "COPYING THE SERVICE"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "REALODING DEAMON"

systemctl enable user  &>>$LOGFILE

VALIDATE $? "ENABLING USER"

systemctl start user &>>$LOGFILE

VALIDATE $? "STARTING USER"

cp /home/centos/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "COPYTING THE SERVICE"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $/ "INSTALLING MONGODB CLIENT"

mongo --host 172.31.88.38 </app/schema/user.js &>>$LOGFILE

VALIDATE $? "LOADING SCHEMA"
