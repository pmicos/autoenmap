#!/bin/bash

# Parameter verify
if [ $# -eq 0 ]; then
  echo "Usage: ./autonmap.sh <IP1> <IP2> ..." #$0
  exit 1
fi

for arg in "$@"; do
	
	echo "-------------------------------------------------------------------------------------------"
	echo "IP address: $arg";
	echo "-------------------------------------------------------------------------------------------"
	
	# IP address
	ip="$arg"

	# Port discover
	sudo nmap -sS -Pn -n --min-rate 5000 -p- --open $ip -oG "$ip-ports"

	# Port extraction
	ports="$(grep -oP '(\d+)/open' $ip-ports | awk -F/ '{print $1}' | tr '\n' ',' | sed 's/,$//')"

	echo "-------------------------------------------------------------------------------------------"
	echo "Ports discovered: $ports"
	echo "-------------------------------------------------------------------------------------------"

	# Port service scan
	sudo nmap -sCV -p$ports $ip -oN "$ip-details"

done


echo "-------------------------------------------------------------------------------------------"
echo "Scan completed - Results saved on 'IP-details' file"
echo "-------------------------------------------------------------------------------------------"
