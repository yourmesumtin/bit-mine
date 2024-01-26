#!/bin/bash

log_file="web.log"

ips=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$log_file")

declare -A ip_count
for ip in $ips; do
    ((ip_count[$ip]++))
done

echo "IP Address   Frequency"
echo "-----------------------"
for ip in "${!ip_count[@]}"; do
    echo "$ip       ${ip_count[$ip]}"
done | sort -k2,2nr








