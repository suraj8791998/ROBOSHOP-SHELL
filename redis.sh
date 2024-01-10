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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "OPENING THE REPO FILE"

yum module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "ENABLING REDIS 6.2 VERSION"

yum install redis -y  &>> $LOGFILE

VALIDATE $? "INSTALLING REDIS 6.2 VERSION"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>> $LOGFILE

VALIDATE $? "UPDATING BIND IP ADDRESS"

systemctl enable redis &>> $LOGFILE

VALIDATE $? "ENABLING REDIS"

systemctl start redis &>> $LOGFILE

VALIDATE $? "STARTING REDIS"