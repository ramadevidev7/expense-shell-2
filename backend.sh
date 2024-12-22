#!/bin/bash


USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)    # $0  is fto find the script name 
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log   #/ creating a log file 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter db password"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then 
   echo -e "$2....$R  failure  $N"
   exit 1
   else 
   echo -e "$2 ....$G  success $N"
   fi 
}

if [ $USERID -ne 0 ]
then 
echo "please run this script as a superuser "
exit 1 
else 
echo "you are a super user "
fi


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabling default node js "

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling nodejs :20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodejs"

id expense
if [ $? -ne 0 ]
then
    useradd expense -y &>>$LOGFILE
    VALIDATE $? "creating expense user"
    else
    echo -e  "expense user is already created... $Y skipping $N "
    fi

    mkdir -p /app
    VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

VALIDATE $? "downloading back end code"

cd /app
unzip /tmp/backend.zip
VALIDATE $? "extracted backend code"

npm install
VALIDATE $? "installing nodejs dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service#!/bin/bash

