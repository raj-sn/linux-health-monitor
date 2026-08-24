#!/bin/bash

CPU=$(top -bn1 | grep "Cpu")

MEMORY=$(free -h)

DISK=$(df -h)

UPTIME=$(uptime)

SSH_STATUS=$(systemctl is-active ssh)
DOCKER_STATUS=$(systemctl is-active docker)

FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)

ERRORS=$(journalctl -p err -n 20)

REPORT="reports/report_$(date +%F).txt"

echo "===== LINUX HEALTH REPORT =====" > $REPORT

echo "" >> $REPORT

echo "CPU:" >> $REPORT
echo "$CPU" >> $REPORT

echo "" >> $REPORT

echo "MEMORY:" >> $REPORT
echo "$MEMORY" >> $REPORT

echo "" >> $REPORT

echo "DISK:" >> $REPORT
echo "$DISK" >> $REPORT

echo "" >> $REPORT

echo "UPTIME:" >> $REPORT
echo "$UPTIME" >> $REPORT

echo "" >> $REPORT

echo "SSH SERVICE: $SSH_STATUS" >> $REPORT
echo "DOCKER SERVICE: $DOCKER_STATUS" >> $REPORT

echo "" >> $REPORT

echo "FAILED SSH LOGINS: $FAILED_LOGINS" >> $REPORT


CPU_PERCENT=$(top -bn1 | grep "Cpu" | awk '{print $2}' | cut -d. -f1)

if [ "$CPU_PERCENT" -gt -1 ]
then
    echo "WARNING: CPU HIGH"
fi


DISK_PERCENT=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_PERCENT" -gt 0 ]
then
    echo "WARNING: DISK LOW"
fi

if [ "$SSH_STATUS" != "active" ]
then
    sudo systemctl restart ssh
fi