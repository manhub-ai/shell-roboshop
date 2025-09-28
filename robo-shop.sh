#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SECURITY_ID="sg-062ee2abee617cab7" # replace with your Security ID and allow all traffic
ZONE_ID="Z011643715JP8CMWCW5FX" # replace with your hosted zone ID
DOMAIN_NAME="manjunatha.space"
	
for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SECURITY_ID  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text )
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text )
        RECORD_NAME="$DOMAIN_NAME"
    fi

    echo "$instance: $IP"


    # Creates route 53 records based on env name

        aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONE_ID \
        --change-batch '
        {
            "Comment": "updating a record set"
            ,"Changes": [{
            "Action"              : "UPSERT"
            ,"ResourceRecordSet"  : {
                "Name"              : "'$RECORD_NAME'"
                ,"Type"             : "A"
                ,"TTL"              : 1
                ,"ResourceRecords"  : [{
                    "Value"         : "' $IP '"
                }]
            }
            }]
        }
        '
done
