#!/usr/bin/bash/env bash
#Version 0.0.1
#mm.sh
#Automatic monitoring mode for RTL8814AU.
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi
#enable for debian
#if ! dpkg-query -W -f='${Status}' iw | grep "ok installed"; then apt install iw; fi
#if ! dpkg-query -W -f='${Status}' pcregrep | grep "ok installed"; then apt install pcregrep; fi
wld=`nmcli | pcregrep -M '^\bwl.*\:\sdisconnected\n\t\"Realtek RTL8814AU' | pcregrep '\bwl.*\d' | sed 's/\:\sdisconnected$//'`

echo "Your RTL8814AU device name is: $wld"
echo "Enter Monitor Mode, Enter Monitor Mode & Start Bettercap, Exit Monitor Mode (Managed Mode)."

select mm in "Monitor-Mode" "Bettercap" "Managed-Mode"; do
		case $mm in
	Monitor-Mode )
		echo "Shutting down wireless device..."; ip link set $wld down;
		echo "Setting wireless device to monitor mode..."; iw dev $wld set type monitor;
		echo "Setting the transmit power to 30 dBm..."; iw dev $wld set txpower fixed 3000;
		echo "Bringing wireless device back up..."; ip link set $wld up;
		echo "Checking information..."; iw dev $wld info | grep -w "type\|txpower"; break;;
	Bettercap ) 
		echo "Shutting down wireless device..."; ip link set $wld down;
		echo "Setting wireless device to monitor mode..."; iw dev $wld set type monitor;
		echo "Setting the transmit power to 30 dBm..."; iw dev $wld set txpower fixed 3000;
		echo "Bringing wireless device back up..."; ip link set $wld up;
		echo "Checking information..."; iw dev $wld info | grep -w "type\|txpower";
		echo "Starting Bettercap..."; bettercap -iface $wld; break;;
	Managed-Mode) 
		echo "Shutting down wireless device..."; ip link set $wld down;
		echo "Setting wireless device to managed mode..."; iw dev $wld set type managed;
		echo "Setting the transmit power to 20 dBm..."; iw dev $wld set txpower fixed 2000;
		echo "Bringing wireless device back up..."; ip link set $wld up;
		echo "Checking information..."; iw dev $wld info | grep -w "type\|txpower"; break;;
	esac
done
exit