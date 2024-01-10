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

yum install maven -y &>>$LOGFILE

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

cd /app &>>$LOGFILE

unzip /tmp/shipping.zip &>>$LOGFILE

mvn clean package &>>$LOGFILE

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl enable shipping &>>$LOGFILE

systemctl start shipping &>>$LOGFILE

yum install mysql -y &>>$LOGFILE

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$LOGFILE

systemctl restart shipping &>>$LOGFILE