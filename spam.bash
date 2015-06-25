#!/bin/bash

IPTABLES=/usr/sbin/iptables
COUNTRY=$1

$IPTABLES -F ANTISPAM${COUNTRY}  2> /dev/null
$IPTABLES -D INPUT -j ANTISPAM${COUNTRY}
$IPTABLES -X ANTISPAM${COUNTRY}  2> /dev/null
$IPTABLES -N ANTISPAM${COUNTRY}
$IPTABLES -I INPUT 1 -j ANTISPAM${COUNTRY}

echo "Downloading $COUNTRY.zone"
curl http://www.ipdeny.com/ipblocks/data/countries/${COUNTRY}.zone 2> /dev/null | while read IP
do
        $IPTABLES -A ANTISPAM${COUNTRY} -s $IP -j DROP
done
