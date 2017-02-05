#!/bin/bash
# Check package status, and install needed packages
# Script Start
echo "Checking status of required packages."
curl=/usr/bin/curl
sqlite3=/usr/bin/sqlite3
screen=/usr/bin/screen
subversion=/usr/bin/svn
echo "Checking Sqlite3..."
if [ -e $sqlite3 ]
then
  echo "Sqlite3 is already installed; Skipping."
else
  echo "Installing Sqlite3..."
  apt-get install -y libsqlite3-dev sqlite3
  echo "Done."
fi
echo "Checking Curl..."
if [ -e $curl ]
then
  echo "Curl is already installed; Skipping."
else
  echo "Installing Curl..."
  apt-get install -y curl
  echo "Done."
fi
echo "Checking Screen..."
if [ -e $screen ]
then
  echo "Screen is already installed; Skipping."
else
  echo "Installing Screen..."
  apt-get install -y screen
  echo "Done."
fi
echo "Checking Subversion..."
if [ -e $subversion ]
then
  echo "Removing Subversion; No longer needed for AllStar."
  apt-get autoremove --purge -y subversion
  rm -rf /root/.subversion
  echo "Done"
else
  echo "Subversion isn't installed; Skipping."
fi
echo "checking Asterisk, Libpri, and Dahdi dependencies..."
apt-get install ntpdate libtonezone-dev automake fxload php5-curl libtool autoconf libical-dev libspandsp-dev libneon27-dev libxml2-dev pkg-config unixodbc-dev uuid uuid-dev libsrtp0-dev bc alsa-utils dnsutils -y
sourcesList=$( grep -ic "#deb-src" /etc/apt/sources.list )
if [ $sourcesList -eq 1 ]; then
  sed -i 's/#deb-src/deb-src/' /etc/apt/sources.list
  echo "Installing new dependencies."
  apt-get update; apt-get build-dep dahdi -y
else
  apt-get build-dep dahdi -y
fi
echo "Done"
exit 0
