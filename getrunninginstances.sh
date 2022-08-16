#!/usr/bin/bash

aws ssm describe-instance-information \
    --query \
    'InstanceInformationList[*].[InstanceId,PlatformName]' \
    --filter "Key=PlatformTypes,Values=Linux" \
    --output text \
    > instances.txt

UBUNTU=`cat instances.txt | awk '$2 == "Ubuntu" {print $1}'`
UBUNTU=`echo $UBUNTU | sed 's/ /,/g'`

RHEL=`cat instances.txt | awk '$2 != "Ubuntu" {print $1}' | sed 's/\s/,/g'`
RHEL=`echo $RHEL | sed 's/ /,/g'`

aws ssm send-command \
    --targets "Key=instanceIds,Values=[$UBUNTU]" \
    --document-name "AWS-RunShellScript" \
    --parameters '{"commands":["sudo apt update","sudo apt upgrade --with-new-pkgs -y", "sudo reboot"]}' \
    --output text \
    > ubuntu.txt


aws ssm send-command \
    --targets "Key=instanceIds,Values=[$RHEL]" \
    --document-name "AWS-RunShellScript" \
    --parameters '{"commands":["sudo yum update -y", "sudo reboot"]}' \
    --output text \
    > rhel.txt


