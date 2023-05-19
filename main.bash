#!/bin/bash

get_cpu_usage() {
  top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}'
}

get_memory_usage() {
  free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}'
}

hostname=$(hostname)
kernel=$(uname -r)
cpu=$(grep 'model name' /proc/cpuinfo | uniq | sed -e 's/.*: //')
memory=$(free -m | awk 'NR==2{print $2}')
disk=$(df -h | awk '$NF=="/"{print $2}')

cpu_usage=$(get_cpu_usage)
memory_usage=$(get_memory_usage)

disk_usage=$(df -hP / | awk 'NR==2{print $3}')

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

log_file="system_monitor.log"

if [ -w "$log_file" ]; then
  {
    echo "Timestamp: $timestamp"
    echo "Hostname: $hostname"
    echo "Kernel: $kernel"
    echo "CPU: $cpu"
    echo "Memory: $memory MB"
    echo "Disk: $disk"
    echo "CPU Usage: $cpu_usage"
    echo "Memory Usage: $memory_usage"
    echo "Disk Usage: $disk_usage"
    echo "--------------------------------------"
  } >> "$log_file"

  echo "System monitoring data logged successfully."
else
  echo "Cannot write to log file: $log_file"
fi
