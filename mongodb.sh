#!/bin/bash

#check if user is root or not
USERID=$(id -u)
# Colour Variables
R="\e[31m"
G="\e[32m"
Y="\e[33m"      
B="\e[34m"
M="\e[35m"
C="\e[36m"
W="\e[37m"
N="\e[0m"



LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER

echo "script started at: $(date)" | tee -a $LOG_FILE
if [ $USERID -ne 0 ]; then
    echo "ERROR: Please run this script as root or using sudo"
    exit 1
fi

VALIDATE(){ #functions receive inputs through arguments just like scripts
    if [ $1 -ne 0 ]; then
        echo -e " $2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e " $2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}
    cp mongo.repo /etc.yum.repos.d/mongo.repo 
    VALIDATE $? "Adding MongoDB repo"

    dnf install mongodb-org -y &>>$LOG_FILE
    VALIDATE $? "Installing MongoDB"

    systemctl enable mongod &>>$LOG_FILE
    VALIDATE $? "Enabling MongoDB"

    systemctl start mongod &>>$LOG_FILE
    VALIDATE $? "Starting MongoDB"


