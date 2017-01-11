#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
  echo "Als root Angemeldet"
  
apt-get install git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf

cd /opt/

git clone https://github.com/simono41/shellinabox.git && cd shellinabox

autoreconf -i

./configure && make

cp shellinabox.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable shellinabox.service

# adduser

echo adduser webssh

useradd webssh

mkdir /home/webssh

chmod 770 -R /home/webssh

chown -R webssh /home/webssh

passwd "webssh <<EOT
webssh
webssh
EOT

cp  shellinabox_sshwrapper.sh /home/webssh/

systemctl start shellinabox.service
