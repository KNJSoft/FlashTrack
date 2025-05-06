#!/bin/bash
sudo nmap -sS -p143 -Pn 10.129.2.48 -n --disable-arp-ping --packet-trace --source-port 53

sudo ncat -nv --source-port 53 10.129.2.48 143 #
nslookup -q=TXT -class=CHAOS version.bind <ip> #version
