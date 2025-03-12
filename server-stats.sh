#!/bin/bash

# Vérification des permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Récupération des statistiques système
echo "===== Server Performance Stats ====="

# OS Version
echo "OS Version: $(lsb_release -d | cut -f2)"

# Uptime
echo "Uptime: $(uptime -p)"

# Load Average
echo "Load Average: $(uptime | awk -F 'load average:' '{print $2}')"

# Utilisateurs connectés
echo "Logged in users: $(who | wc -l)"

# CPU Usage
echo "CPU Usage: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%"

# Mémoire Usage
mem_info=$(free -m | awk 'NR==2{printf "Used: %sMB / Total: %sMB (%.2f%%)\n", $3, $2, $3*100/$2 }')
echo "Memory Usage: $mem_info"

# Disk Usage
disk_info=$(df -h / | awk 'NR==2{printf "Used: %sB / Total: %sB (%s)\n", $3, $2, $5}')
echo "Disk Usage: $disk_info"

# Top 5 processes by CPU usage
echo "Top 5 CPU-consuming processes:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR>1 {printf "PID: %s | Process: %s | CPU: %s%%\n", $1, $2, $3}'

# Top 5 processes by Memory usage
echo "Top 5 Memory-consuming processes:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR>1 {printf "PID: %s | Process: %s | Memory: %s%%\n", $1, $2, $3}'

# Failed Login Attempts
failed_attempts=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "Failed Login Attempts: $failed_attempts"

# Fin du script
echo "===== End of Stats ====="
