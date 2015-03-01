# EmptyBox

Create ad-hoc wifi access points that display anything in your `www` folder.

**[Notice: EmptyBox is not yet functional.]**

## What is EmptyBox?

EmptyBox is a fork of the [PirateBox](http://www.piratebox.cc/start) project with modifications that relinquish it from its original purpose. EmptyBox is meant to:

- Promote experimentation using Wifi [Access Points](http://en.wikipedia.org/wiki/Wireless_access_point) (APs) for the purpose of media art, performance, and/or play.
- Be rapidly deployable and well documented for artists or experimenters who wish to create artworks and experiences using [Captive Portal](http://en.wikipedia.org/wiki/Captive_portal) Access Points who might otherwise find this feat challenging or be altogether unfamiliar with these technologies or concepts.

For more information about how EmptyBox differs from PirateBox see the [EmptyBox vs PirateBox](#EmptyBox-vs-PirateBox) section of this document.

## What can you do with it?

EmptyBox allows anyone to deploy their web projects and experiments as their own local wireless Access Points accessible only to those around them. This provides artists and experimenters with a unique audience and scenario.

EmptyBox is great for:

- Connecting people in areas where an Internet or 3G connection is not available.
- Using a custom Wifi network to augment an exhibition or gallery experience.
- Host an off-line Web Art exhibition in a real place (or a collection of them around a city).

Some initial ideas for possible uses include:

- A networked game for riders of the CTA (Chicago Transit Authority).
- A Skype-like application that automatically connects viewers who are already in the same place.
- A LAN style [BBS](http://en.wikipedia.org/wiki/Bulletin_board_system) featuring ASCII art packs.

## Download and Install

EmptyBox is designed to run on the Raspberry Pi (although it can easily run on a laptop or desktop). To use it you will need:

- A Raspberry Pi (any model)
- A USB Wifi dongle that supports packet injection
- ~10 minutes of setup time

You have two options to install EmptyBox on your Raspberry Pi. You may either download the disk image file from ~~here~~ (an RPi distribution of Kali linux v1.0.9 with EmptyBox pre-installed), or you may install EmptyBox on an existing linux based Raspberry Pi distribution by running the following commands from the Pi's terminal:

```
git clone https://github.com/brannondorsey/EmptyBox
cd EmptyBox
./install.sh
```

## Using EmptyBox

### Getting Started

Plug in your Wifi dongle, boot up your RPi, and simply drag your static website into the `/opt/emptybox/www` folder. If you downloaded and installed the RPi disk image EmptyBox should have launched on boot and you can view your web content by connecting to the "EmptyBox" wifi network. If you installed EmptyBox manually, you must run the following command to start EmptyBox:

```
sudo service emptybox start
```

If you have installed EmptyBox yourself, and would like to configure it to launch automatically at boot, run the following command:

```
sudo update-rc.d emptybox defaults
```

When EmptyBox is running, anything in your `/opt/emptybox/www` folder will be served to anyone who is:

1. Connected to your wireless access point.
2. Browsing to a non-https website.

To stop EmptyBox run:

```
sudo service emptybox stop
```

If any components of EmptyBox fail to start, or you are experiencing difficulty in some way, see the [Troubleshooting](#troublehsooting) section of this document.

### Customize Default Settings

Most of the editable settings for EmptyBox exist in the `emptybox/conf` folder.  Notable files include:

- `emptybox.conf`: The default settings file for EmptyBox. Look here first.
- `hostapd.conf`: Change the name of your Wifi network and enable your karma-patched hostapd to lure devices to automatically connect to your network.
- `lighttpd/lighttpd.conf`: The default settings for the default [Lighttpd web server](http://www.lighttpd.net/) that EmptyBox uses.

I recommend changing the default "EmptyBox" network name in `hostapd.conf` to something related to your project, or simply "Public" to lure people into using your network. 

It should be noted that you should not directly edit any configuration files that contain the word "generated" in their name, as these files are generated automatically by EmptyBox and changes that you make may be overwritten. Instead edit the default files of the same name.

This setup and default settings control should suffice for a novice user, or one who is looking to serve only static (HTML, CSS, and JavaScript) content from their Access Point with EmptyBox. More experienced users may benefit from the rest of the content in this README. Read on if you are interested in having more control or aren't afraid of this scary warning message.

### Dynamic Content

#### PHP

Lighttpd supports dynamic web content and scripts like PHP right out of the box provided that you installed the add-on PHP dependency during the install process or already have it installed on you machine. The default PHP settings for EmptyBox exist in the `/opt/emptybox/conf/lighttpd/fastcgi.conf` file. For more information about using PHP with Lighttpd, read this [tutorial](http://redmine.lighttpd.net/projects/1/wiki/tutoriallighttpdandphp).

#### Alternative Webserver

To use your own web server with EmptyBox edit the `USE_LIGHTTPD`, `ALT_WEBSERVER_EXEC`, and `ALT_WEBSERVER_ARGS` variables in `conf/emptybox.conf`. For instance, if I wanted to use EmptyBox with a Node.js server running on port 80, my configuration might look like this:

```
USE_LIGHTTPD="no"
ALT_WEBSERVER_EXEC="/usr/local/bin/node"
ALT_WEBSERVER_ARGS="/path/to/server.js --foo=bar"
```

This configuration use my `/path/to/server.js` web server instead of the default Lighttpd web server. Note that if you have created your own web server you are no longer bound to using the default `/opt/emptybox/www` folder to serve your web content.

## Digging Deeper

### Directory Overview

Once installed, EmptyBox uses the directory in `/opt/emptybox`. Note that if you installed from git, any changes you make to the cloned repository will not take effect unless you reinstall. You should instead edit the files in the `/opt/emptybox` directory.

- `/opt/emptybox/bin`: Binarys and Scripts
- `/opt/emptybox/conf`:  EmptyBox related configs
- `/opt/emptybox/init.d`: The init-script that `/etc/init.d` symlinks to
- `/opt/emptybox/www`: Public Web folder served by EmptyBox
- `/opt/emptybox/tmp`: Error-log, Process IDs, DHCP lease file, etc...

### Changing Directory

If you decide not to run piratebox under `/opt` you have to change following scripts before install:

- `emptybox/conf/emptybox.conf`
- `emptybox/conf/lighttpd/lighttpd.conf`
- `emptybox/init.d/emptybox`


### Using Hooks

Several hooks exist in the `/opt/emptybox/bin/hooks` directory so that you may cleanly apply your own custom shell scripts at key points during the start and stop processes of EmptyBox. There exists also one custom configuration hook that can be used to create and set custom variables in `/opt/emptybox/conf/hook_custom.conf`.

## Troubleshooting

### Wireless Device Fails to Start

EmptyBox uses the wireless interface `wlan0` by default. Your wireless card may automatically choose a different name and thus be undiscoverable by EmptyBox's default settings. To list your network interfaces type `ifconfig` into your terminal. If you see an output listing `wlan1` (or higher) like this:

```
wlan1     Link encap:Ethernet  HWaddr c8:25:4f:45:ae:4c  
          inet addr:192.168.77.1  Bcast:192.168.77.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:26 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:3374 (3.2 KiB)
```

Then you must change the value of `INTERFACE` and `DNSMASQ_INTERFACE` in `/opt/emptybox/conf/emptybox.conf` to match the name of your wireless interface.

### No Wireless Network Advertised

Check to make sure that EmptyBox is running with:

```
ps aux | grep emptybox
```
If EmptyBox is up you should see an output like this:

```
root      2467  8.3  0.4   5764  1840 ?        S    00:04   0:00 /usr/sbin/hostapd /opt/emptybox/conf/hostapd.conf
nobody    2508  0.2  0.1   4732   884 ?        S    00:04   0:00 /usr/sbin/dnsmasq -x /var/run/emptybox_dnsmasq.pid -C /opt/emptybox/conf/dnsmasq_generated.conf
nobody    2532  0.2  0.2   6512   972 ?        S    00:04   0:00 /usr/sbin/lighttpd -f /opt/emptybox/conf/lighttpd/lighttpd.conf
root      2554  0.0  0.1   3488   836 pts/0    S+   00:04   0:00 grep emptybox
```
If not, run the following to start EmptyBox:

```
sudo service emptybox start
```

Note that the `hostapd /opt/emptybox/conf/hostapd.conf` is the command that actually advertises your ad-hoc network. If for some reason EmptyBox is running, but `hostapd` is not, then your network will not be reachable.

### A Wireless Card Has Previously Been Setup to Access a Network On Your Machine

If the contents of your `/etc/network/interfaces` file looks something like this:

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
```

Where `wlan0` is the network interface you are trying to use with EmptyBox, comment out the bottom four lines (or ones that are similar and pertain to the interface), replacing them with:

```
iface wlan0 inet manual
```

Reboot your RPi for these changes to take effect.

## EmptyBox vs PirateBox

EmptyBox primarily differs from PirateBox in that it:

- Removes all PirateBox webpage content (the `www/` folder) and provides instructions on how to use your own static or dynamic content.
- Supports use of a Karma patched version of Hostapd (allowing EmptyBox to be setup so that its network is automatically connected to).
- Is encouraged to be run on a Kali Linux distribution on the Raspberry Pi.
- Provides documentation and support that stresses using the code and features that PirateBox developed to auto-deploy a Captive Portal Access Point independent of its "DIY anonymous offline file-sharing and communications system."

Many Piratebox scripts have been remove or altered, however the basic architecture and methodology that Piratebox employs remains unchanged with it's EmptyBox fork. The short process of modifying Piratebox to become EmptyBox was one that was primarily reductive rather than additive. Also, every instance of the name "Piratebox" was, for the most part, changed to "EmptyBox" as a means to disambiguate projects as well as to keep from confusing users unfamiliar with the Piratebox project or source code. This act was in no way intending to steal code from Piratebox using it only as a different name. A list of explicit changes made to the Piratebox v1.0.2 source code that were made to create EmptyBox can be found in the [CHANGELOG](CHANGELOG) file in this repository.

## License and Credit

EmptyBox is developed and maintained by Brannon Dorsey using code that was mostly written and inspired by David Darts, Matthias Strubel, and a host of other contributors.

It is released under the [GPL-3](http://www.gnu.org/copyleft/gpl.html) license:

© 2011-2014 Matthias Strubel (PirateBox code)<br>
© 2015 Brannon Dorsey (EmptyBox modifications)



