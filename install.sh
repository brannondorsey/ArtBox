#!/bin/bash
#=======================================================================
#
#          FILE:  install.sh
# 
#         USAGE:  ./install.sh 
# 
#   DESCRIPTION:  Install file for EmptyBox (a fork of PirateBox). 
# 
#       OPTIONS:  ./install.sh
#  REQUIREMENTS:  ---
#          BUGS:  Link from install
#         NOTES:  ---
#        AUTHOR: Cale 'TerrorByte' Black, cablack@rams.colostate.edu
#        AUTHOR: Brannon Dorsey, brannon@brannondorsey.com (updates for EmptyBox)
#       COMPANY:  ---
#       CREATED: 02.02.2013 19:50:34 MST
#       UPDATED: 02.22.2015 by Brannon Dorsey
#      REVISION:  0.3.1
#=======================================================================

#Import EmptyBox conf
CURRENT_CONF=emptybox/conf/emptybox.conf
scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"

#Must be root
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" #1>&2
        exit 0
fi

if [[ -f  "$CURRENT_DIR"/$CURRENT_CONF ]]; then
	. $CURRENT_CONF 2> /dev/null
else
	echo "EmptyBox config is not in its normal directory."
	echo "Expecting it in \"$CURRENT_DIR/$CURRENT_DIR\"."
	exit 0
fi

#begin setting up emptybox's home dir
if [[ ! -d /opt ]]; then
	mkdir -p /opt
fi

#if emptybox already exists remove it
if [[ -d /opt/emptybox ]]; then
	echo -n "EmptyBox already installed. Would you like to overwrite it? (Y/n):"
	read RESPONSE
	if [[ $RESPONSE = "Y" || $RESPONSE = "y" || $RESPONSE = "" ]]; then
		"Removing old /opt/emptybox..."
		rm -rf /opt/emptybox &> /dev/null
	else
		exit 0;
	fi
fi

cp -rv "$CURRENT_DIR"/emptybox /opt &> /dev/null
echo "Finished copying files to /opt/emptybox..."

if ! grep "$NET.$IP_SHORT emptybox.lan$" /etc/hosts > /dev/null; then 
	echo "\"$NET.$IP_SHORT emptybox.lan\" was already found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT emptybox.lan to /etc/hosts"
	echo "$NET.$IP_SHORT emptybox.lan">>/etc/hosts
fi

if ! grep "$NET.$IP_SHORT emptybox$" /etc/hosts > /dev/null ; then 
	echo "\"$NET.$IP_SHORT emptybox\" was already found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT emptybox to /etc/hosts"
	echo "$NET.$IP_SHORT emptybox">>/etc/hosts
fi

if [[ -d /etc/init.d/ ]]; then
	ln -sf /opt/emptybox/init.d/emptybox /etc/init.d/emptybox
	echo "To make EmptyBox start at boot run: update-rc.d emptybox defaults"
#	systemctl enable emptybox #This enables EmptyBox at start up... could be useful for Live
else
	#link between opt and etc/pb
	ln -sf /opt/emptybox/init.d/emptybox.service /etc/systemd/system/emptybox.service
	echo "To make EmptyBox start at boot run: systemctl enable emptybox"
fi

#install dependencies
#TODO missing anything in $DEPENDENCIES?
# Modified Script by martedì at http://www.mirkopagliai.it/bash-scripting-check-for-and-install-missing-dependencies/
PKGSTOINSTALL="hostapd lighttpd dnsmasq"
EXTRAPKGSTOINSTALL="php5-cgi macchanger"

# If some dependencies are missing, asks if user wants to install
if [ "$PKGSTOINSTALL" != "" ]; then
	
	echo "EmptyBox requires the following dependencies:"
	echo "	$PKGSTOINSTALL"
	echo -n "Would you like to install them now? (Y/n):"
	read PKGSURE

	if [ "$EXTRAPKGSTOINSTALL" != "" ]; then
		echo "EmptyBox supports the following addon dependencies:"
		echo "	$EXTRAPKGSTOINSTALL"
		echo -n "Would you like to install them now? (Y/n):"
		read EXTRAPKGSURE
	fi

	# If user want to install missing dependencies
	if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" || $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]] ; then
		# Debian, Ubuntu and derivatives (with apt-get)
		if which apt-get &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				apt-get install $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				apt-get install $PKGSTOINSTALL
			fi
		# OpenSuse (with zypper)
		#elif which zypper &> /dev/null; then
		#	zypper in $PKGSTOINSTALL
		# Mandriva (with urpmi)
		elif which urpmi &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				urpmi $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				urpmi $PKGSTOINSTALL
			fi
		# Fedora and CentOS (with yum)
		elif which yum &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				yum install $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				yum install $PKGSTOINSTALL
			fi
		# ArchLinux (with pacman)
		elif which pacman &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				pacman -Sy $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				pacman -Sy $PKGSTOINSTALL
			fi
		# Else, if no package manager has been found
		else
			# Set $NOPKGMANAGER
			NOPKGMANAGER=TRUE
			echo "ERROR: No package manager found. Please, manually install:"
			echo "	$PKGSTOINSTALL"
			echo "and (optional):"
			echo "	$EXTRAPKGSTOINSTALL"
		fi
	fi
fi

/opt/emptybox/bin/install_emptybox.sh /opt/emptybox/conf/emptybox.conf part2

echo -n "Would you like to install a crontab to automatically provide the number of connected clients to your www folder? (Y/n):"
read INSTALL_STATION_CNT
if [[ INSTALL_STATION_CNT == "Y" || INSTALL_STATION_CNT == "y" || INSTALL_STATION_CNT == "" ]]; then
	/opt/emptybox/bin/install_emptybox.sh /opt/emptybox/conf/emptybox.conf station_cnt
	[ "$?" == "0" ] echo "Crontab installed. View number of connected station clients at www/station_cnt.txt"
fi

echo ""
echo "##############################"
echo "#EmptyBox has been installed#"
echo "##############################"
echo ""
echo "Use: sudo service emptybox <start|stop>"
echo "or for systemd systems Use: sudo systemctl <start|stop|restart> emptybox"
echo "To make EmptyBox start at boot run: update-rc.d emptybox defaults"
exit 0
