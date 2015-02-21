# ArtBox

Wifi as an art medium.

**[Notice: ArtBox is not yet functional.]**

## What is ArtBox?

ArtBox is a fork of the [PirateBox](http://www.piratebox.cc/start) project with modifications that relinquish it from its original purpose. ArtBox is meant to:

- Promote experimentation with using Wifi [Access Points](http://en.wikipedia.org/wiki/Wireless_access_point) (APs) for the purpose of media art and performance.
- Be rapidly deployable and well documented for artists who wish to create artworks and experiences using [Captive Portal](http://en.wikipedia.org/wiki/Captive_portal) Access Points who might otherwise find this feat challenging or be altogether unfamiliar with these technologies or concepts.

For more information about how ArtBox differs from PirateBox check out the [ArtBox vs PirateBox](#ArtBox-vs-PirateBox) section of this document.

## What can you do with it?

ArtBox allows an artist to deploy their Web Art projects and experiments as their own local wireless Access Points viewable only to those around them. This provides artists with a unique audience and scenario.

ArtBox is great for:

- Connecting people in areas where an Internet or 3G connection is not available.
- Using a custom Wifi network to augment an exhibition or gallery experience.
- Host an off-line Web Art exhibition in a real place (or a collection of them around a city).

Some initial ideas for possible uses include:

- A networked game for riders of the CTA (Chicago Transit Authority).
- A Skype-like application that automatically connects viewers who are already in the same place.
- A LAN style BBS featuring ASCII art packs.

## ArtBox vs PirateBox

ArtBox differs from PirateBox in that it:

- Removes all PirateBox webpage content (the `www/` folder) and provides detailed instructions on how to use your own static or dynamic content.
- Uses a Karma patched version of Hostapd (allowing ArtBox to be setup so that its network is automatically connected to).
- Runs on a Kali Linux distribution on the Raspberry Pi.
- Provides documentation and support that stresses using the code and features that PirateBox developed to auto-deploy a Captive Portal Access Point independent of its "DIY anonymous offline file-sharing and communications system." 

## License and Credit

ArtBox is developed and maintained by Brannon Dorsey using code that was mostly written and inspired by David Darts, Matthias Strubel, and a host of other contributors.

It is released under the GPL-3 license:

© 2012-2014 Matthias Strubel (PirateBox code)<br>
© 2015 Brannon Dorsey (ArtBox modifications)



