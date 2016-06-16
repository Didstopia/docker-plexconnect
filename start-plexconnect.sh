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

if [ ! -f /opt/PlexConnect/ATVSettings.cfg ]; then
	ln -s /plexconnect/ATVSettings.cfg /opt/PlexConnect/ATVSettings.cfg
fi

cp /plexconnect/trailers.* assets/certificates/

if [ ! -f /plexconnect/Settings.cfg ]; then
	echo [PlexConnect] > /plexconnect/Settings.cfg
	env | grep ^PLEXCONNECT_ | sed -E -e 's/^PLEXCONNECT_//' -e 's/(.*)=/\L\1 = /' >> /plexconnect/Settings.cfg
else
	rm -fr /opt/PlexConnect/Settings.cfg
fi

ln -s /plexconnect/Settings.cfg /opt/PlexConnect/Settings.cfg

echo
echo 'Using Settings.cfg:'
grep . /opt/PlexConnect/Settings.cfg
echo

./PlexConnect.py
