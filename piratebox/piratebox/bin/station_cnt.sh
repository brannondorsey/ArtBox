#!/bin/sh
CNT=`iw wlan0 station dump | grep Station | wc -l`
echo CNT
