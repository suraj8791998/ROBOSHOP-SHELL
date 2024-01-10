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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "INSTALLING NGINX"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "ENABLING NGINX"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "STARTING NGINX"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "REMOVING HTML DEFAULT FILE"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "DOWNLOADING APPLICATION"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "MOVING TO THE HTML DEFAULT PATH"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "UNZIPPING APPLICATION"

cp /home/centos/ROBOSHOP-SHELL/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "COPYING ROBOSHOP SERVICE"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "RESTARTING NGINX"