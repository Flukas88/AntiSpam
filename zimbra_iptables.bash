#!/bin/bash

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
iptables -I INPUT -p tcp --dport 80 -j ACCEPT #HTTP (for webmail)
# Drop POP3
iptables -A INPUT -p tcp --dport 110 -j DROP
