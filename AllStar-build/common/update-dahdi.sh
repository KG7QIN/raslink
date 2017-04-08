#! /bin/bash
# Used to build Dahdi for AllStar

# Script Start
echo "Downloading and unpacking dahdi..."
cd /usr/src/utils/
if [ -e /usr/src/utils/astsrc/dahdi* ]
then
  rm -rf /usr/src/utils/astsrc/dahdi*
fi
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz &>/dev/null
cd /usr/src/utils/astsrc/
tar zxvf /usr/src/utils/dahdi-linux-complete-current.tar.gz &>/dev/null
mv dahdi* dahdi
rm -rf /usr/src/utils/*.tar.gz
echo "Done"
cd /usr/src/utils/astsrc/dahdi/
echo "Building dahdi..."
# Patch dahdi for use with AllStar
# https://allstarlink.org/dude-dahdi-2.10.0.1-patches-20150306
patch -p1 < /usr/src/utils/AllStar-build/patches/patch-dahdi-dude-current
# remove setting the owner to asterisk
patch -p0 < /usr/src/utils/AllStar-build/patches/patch-dahdi.rules
# Build and install dahdi
make; make install; make config
if [ `grep -ic "dahdi" /etc/modules` = "0" ]; then
  echo "dahdi" >> /etc/modules
  modprobe dahdi
fi
echo "Done"
exit 0
