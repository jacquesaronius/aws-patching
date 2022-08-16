#!/usr/bin/bash
U_CMD=`cat ubuntu.txt | awk 'NR==1{print $2}'`
R_CMD=`cat rhel.txt | awk 'NR==1{print $2}'`

aws ssm list-command-invocations \
    --command-id "$U_CMD" \
    --details \
    > ubuntu.json
aws ssm list-command-invocations \
    --command-id "$R_CMD" \
    --details \
    > rhel.json