#!/bin/bash

LOG_FILE="/var/log/monitor_sistema.log"

#Crea archivo si no existe
touch $LOG_FILE

while true
do
	echo "==========================" >> $LOG_FILE
	echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG_FILE
	echo "PID | Nombre | %CPU | %MEM">> $LOG_FILE

	ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | tail -n 5 >> $LOG_FILE

	sleep 5
done
