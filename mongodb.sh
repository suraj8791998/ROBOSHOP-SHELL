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

cp mongo.repo /etc/yum.repos.d/mongo.repo