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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "INSTALLING PYTHON"

useradd roboshop &>>$LOGFILE

VALIDATE $? "ADDING USER"

mkdir /app  &>>$LOGFILE

VALIDATE $? "CREATING FOLDER"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app &>>$LOGFILE

VALIDATE $? "MOVING TO THE APP"
 
unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "UNZIPPING APPLICATION"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "INSATALLING DEPENDENCIES"

cp /home/centos/ROBOSHOP-SHELL/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "COPYING SERVICE"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "RELOADING DEAMON"
 
systemctl enable payment  &>>$LOGFILE

VALIDATE $? "ENABLING PAYMENT"

systemctl start payment &>>$LOGFILE

VALIDATE $? "STARTING PAYMENT"