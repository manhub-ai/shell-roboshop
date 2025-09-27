#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SECURITY_ID="sg-062ee2abee617cab7" # replace with your Security ID and allow all traffic
	
for instance in $@
do
    aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-062ee2abee617cab7  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Instances[0].PublicIpAddress' --output text	


done
