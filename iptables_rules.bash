#!/bin/bash

iptables -I INPUT -p tcp --dport 22 -j DROP #SSH
iptables -I INPUT -p tcp --dport 2223 -j ACCEPT #SSH
iptables -I INPUT -p tcp --dport 25 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT #HTTPS
iptables -I INPUT -p tcp --dport 3930 -j ACCEPT
iptables -I INPUT -p tcp --dport 143 -j ACCEPT #IMAP
iptables -I INPUT -p tcp --dport 993 -j ACCEPT #IMAPS
iptables -I INPUT -p tcp --dport 389 -j ACCEPT #LDAP
iptables -I INPUT -p tcp --dport 7025 -j ACCEPT
iptables -I INPUT -p tcp --dport 5800 -j ACCEPT
iptables -I INPUT -p tcp --dport 5900 -j ACCEPT
iptables -I INPUT -p tcp --dport 7071 -j ACCEPT #Port for ZCS Web Administration
iptables -I INPUT -p tcp --dport 3894 -j ACCEPT
iptables -I INPUT -p tcp --dport 3895 -j ACCEPT
iptables -A INPUT -p tcp --dport 465 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 161 -j ACCEPT # SNMP
iptables -I INPUT -p tcp --dport 80 -j ACCEPT #HTTP (for webmail)
iptables -A INPUT -p tcp --dport 6556 -j ACCEPT # check_mk
# Drop POP3
iptables -A INPUT -p tcp --dport 110 -j DROP
#### ICMP
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp --fragment -j DROP
# Block fragmented ICMP.
# Allow incoming Path MTU Discovery (ICMP destination-unreachable/fragmentation-needed)
iptables -A INPUT -p icmp --icmp-type 3/4 -m state --state NEW -j ACCEPT
# Allow incoming request to decrease rate of sent packets (ICMP Source Quench)
iptables -A INPUT -p icmp --icmp-type 4 -m state --state NEW -j ACCEPT
# Allow and throttle incoming ping (ICMP Echo-Request).
iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW -m limit --limit 2/s --limit-burst 5 -j ACCEPT
# Drop invalid packets immediately
iptables -A INPUT   -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT  -m state --state INVALID -j DROP
# Drop bogus TCP packets
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
