#!/bin/bash

INSTANCE_ID="i-0123456789abcdef0"

aws cloudwatch put-metric-alarm \
  --alarm-name "HighCPUAlarm" \
  --alarm-description "Alarm when CPU exceeds 80% for 5 minutes" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 60 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=${INSTANCE_ID} \
  --evaluation-periods 5 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:NotifyMe \
  --unit Percent
