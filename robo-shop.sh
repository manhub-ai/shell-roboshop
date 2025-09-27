#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SECURITY_ID="sg-062ee2abee617cab7" # replace with your Security ID and allow all traffic
	
for instance in $@
do
    INSTANCE_ID=(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids sg-062ee2abee617cab7  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Instances[0].PublicIpAddress' --output text)

    if [ $instance != "frontend" ]; then
        IP=(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text )
    else
        IP=(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text )
    fi
    echo "$instance: $IP"
done
