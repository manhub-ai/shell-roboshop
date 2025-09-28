#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-062ee2abee617cab7" # replace with your SG ID
AWS="/usr/local/bin/aws"
#ZONE_ID="Z011643715JP8CMWCW5FX" # replace with your ID
#DOMAIN_NAME="manjunatha.space"


for instance in $@ # mongodb redis mysql
do
    INSTANCE_ID=$($AWS ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids sg-062ee2abee617cab7 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Instances[0].InstanceId' --output text)

    # Get Private IP
    if [ $instance != "frontend" ]; then
        IP=$(aw$AWSs ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
        #RECORD_NAME="$instance.$DOMAIN_NAME" # mongodb.manjunatha.space
    else
        IP=$($AWS ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
        #RECORD_NAME="$DOMAIN_NAME" # manjunatha.space
    fi

    echo "$instance: $IP"

    
done