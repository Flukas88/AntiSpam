#!/bin/bash

iptables -A INPUT -p udp -m udp --dport 161 -j ACCEPT # SNMP
iptables -A INPUT -p tcp --dport 6556 -j ACCEPT # check_mk
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
