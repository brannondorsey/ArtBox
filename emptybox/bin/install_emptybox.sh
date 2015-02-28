#!/bin/sh
## EmptyBox installer script  v.01
##  created by Matthias Strubel   2011-08-04
##  updated for ArtBox by Brannon Dorsey 2015-02-22

## ASH does not support arrays, so no nice foreach 
# All Perl packages for kareha
##OPENWRT_PACKAGES_IMAGEBOARD=(  perl perlbase-base perlbase-cgi perlbase-essential perlbase-file perlbase-bytes perlbase-config perlbase-data perlbase-db-file perlbase-digest perlbase-encode perlbase-encoding perlbase-fcntl perlbase-gdbm-file perlbase-integer perlbase-socket perlbase-unicode perlbase-utf8 perlbase-xsloader  )



# Load configfile

if [ -z  $1 ] || [ -z $2 ]; then 
  echo "Usage install_emptybox my_config <part>"
  echo "   Parts: "
  echo "       part2          : sets Permissions and links correctly"
  echo "       station_cnt        : Adds Statio counter to your Box - crontab entry"
  echo "       flush_dns_reg      : Installs crontask to flush dnsmasq regulary"
  echo "       hostname  'name'   : Exchanges the Hostname displayed in browser"
  exit 1
fi


if [ !  -f $1 ] ; then 
  echo "Config-File $1 not found..." 
  exit 1 
fi

#Load config
EMPTYBOX_CONFIG=$1
. $1 

if [ $2 = 'part2' ] ; then
   echo "Starting initialize EmptyBox Part2..."
   #Set permissions
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $EMPTYBOX_FOLDER/www -R
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $EMPTYBOX_FOLDER/tmp
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $EMPTYBOX_FOLDER/tmp -R
fi 

if [ $2 = "station_cnt" ] ; then
    #we want to append the crontab, not overwrite
    crontab -l   >  $EMPTYBOX_FOLDER/tmp/crontab 2> /dev/null
    echo "#--- Crontab for EmptyBox-Station-Cnt" >>  $EMPTYBOX_FOLDER/tmp/crontab
    echo " */1 * * * *    $EMPTYBOX_FOLDER/bin/station_cnt.sh >  $WWW_FOLDER/station_cnt.txt "  >> $EMPTYBOX_FOLDER/tmp/crontab
    crontab $EMPTYBOX_FOLDER/tmp/crontab
    [ "$?" != "0" ] && echo "an error occured" && exit 254
    $EMPTYBOX_FOLDER/bin/station_cnt.sh >  $WWW_FOLDER/station_cnt.txt
    echo "Crontab installed. Now every 1 minutes your station count is refreshed."
    echo "You can view your station count in www/station_cnt.txt"
fi

if [ $2 = "flush_dns_reg" ] ; then
    crontab -l   >  $EMPTYBOX_FOLDER/tmp/crontab 2> /dev/null
    echo "#--- Crontab for dnsmasq flush" >>  $EMPTYBOX_FOLDER/tmp/crontab
    echo " */2 * * * *    $EMPTYBOX_FOLDER/bin/flush_dnsmasq.sh >  $EMPTYBOX_FOLDER/tmp/dnsmasq_flush.log "  >> $EMPTYBOX_FOLDER/tmp/crontab
    crontab $EMPTYBOX_FOLDER/tmp/crontab
    [ "$?" != "0" ] && echo "an error occured" && exit 254
    echo "Installed crontab for flushing dnsmasq requlary"
fi

set_hostname() {
	local name=$1 ; shift;

	sed  "s|#####HOST#####|$name|g"  $EMPTYBOX_FOLDER/src/redirect.html.schema >  $WWW_FOLDER/redirect.html
        sed "s|HOST=\"$HOST\"|HOST=\"$name\"|" -i  $EMPTYBOX_CONFIG
}

if [ $2 = "hostname" ] ; then
	echo "Switching hostname to $3"
	set_hostname "$3"
	echo "..done"
fi

