#!/bin/bash
log="/var/log/system_alert.log"
log_event() {
	local level=$1
	local service=$2
	local msg=$3
	echo "[$(date '+%Y-%M-%d %H:%M:%S')] |  $level     |   $service   |   $msg  " >> $log
	}
if [ "$(systemctl is-active nginx)" != "active" ]; then 
	log_event  "critical" "nginx" "service is Down"
else 
	log_event "INFO" "nginx" "service is active"
fi
if [ $(df -h / | awk 'NR==2 {print $5}' | sed 's/%//') -gt 80 ]; then
	log_event "WARNING" "Disk usage" "Usage is height : $(df -h / |awk 'NR==2 {print $5}')"
else 
	log_event "INFO" "Disk usage " "usage is normal"
fi
ram=$(free |grep Mem| awk '{print int($3/$2 * 100)}')
if [ "$ram" -gt 80 ];then
	log_event "WARNING" "RAM" "Usage is height : $ram"
else
	log_event "INFO" "RAM" "Usage is normal: $ram" 
fi
