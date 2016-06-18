#!/bin/sh -e

cd /opt/PlexConnect

if [ ! -f /plexconnect/trailers.cer ]; then
  echo "Generating SSL certificate"
  openssl req -new -nodes -newkey rsa:2048 \
    -out /plexconnect/trailers.pem -keyout /plexconnect/trailers.key \
    -x509 -days 7300 -subj "/C=US/CN=trailers.apple.com"
  openssl x509 -in /plexconnect/trailers.pem -outform der -out /plexconnect/trailers.cer \
    && cat /plexconnect/trailers.key >> /plexconnect/trailers.pem
fi

# Symbolic linking and creation of ATVSettings.cfg
if [ ! -f /plexconnect/ATVSettings.cfg ]; then
  echo [PlexConnect] > /plexconnect/ATVSettings.cfg
else
  rm -fr /opt/PlexConnect/ATVSettings.cfg
fi
ln -s /plexconnect/Settings.cfg /opt/PlexConnect/Settings.cfg

cp /plexconnect/trailers.* assets/certificates/

# Symbolic linking and creation of Settings.cfg
if [ ! -f /plexconnect/Settings.cfg ]; then
	echo [PlexConnect] > /plexconnect/Settings.cfg
else
	rm -fr /opt/PlexConnect/Settings.cfg
fi
ln -s /plexconnect/Settings.cfg /opt/PlexConnect/Settings.cfg

echo
echo 'Using Settings.cfg:'
grep . /opt/PlexConnect/Settings.cfg
echo

./PlexConnect.py
