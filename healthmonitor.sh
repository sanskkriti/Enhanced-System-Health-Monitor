#!/bin/bash

# Function to check CPU usage and load averages
check_cpu() {
    echo "=== CPU Usage ==="
    echo "CPU Load Averages (1, 5, 15 min): $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "  %.2f%%\n", 100 - $1}'
    echo
}

# Function to check memory usage
check_memory() {
    echo "=== Memory Usage ==="
    free -h | awk '/^Mem:/ {printf "  Used: %s, Free: %s, Total: %s\n", $3, $4, $2}'
    echo
}

# Function to check disk usage
check_disk() {
    echo "=== Disk Usage ==="
    df -h | awk 'NR>1 {printf "  %s: Used: %s, Free: %s, Total: %s, Usage: %s\n", $1, $3, $4, $2, $5}'
    echo
}

# Function to check system uptime
check_uptime() {
    echo "=== System Uptime ==="
    uptime | awk '{printf "  Uptime: %s\n", $3, $4, $5}'
    echo
}

# Function to check network statistics
check_network() {
    echo "=== Network Statistics ==="
    echo "Network Interfaces:"
    ip -s link | awk '/^[0-9]+:/{print "  " $2}'
    echo
}

# Function to check specific services (e.g., sshd and apache2)
check_services() {
    echo "=== Service Status ==="
    for service in sshd apache2; do
        if systemctl is-active --quiet $service; then
            echo "  $service: Running"
        else
            echo "  $service: Not Running"
        fi
    done
    echo
}

# Main function to run checks
main() {
    echo "=== System Health Check ==="
    check_cpu
    check_memory
    check_disk
    check_uptime
    check_network
    check_services
    echo "==========================="
}

# Execute the main function
main
