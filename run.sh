#!/bin/bash
DESTINATION=$1
PORT=$2
CHAT=$3
# clone Flectra directory
git clone --depth=1 https://github.com/mmoretaoficial/flectra-v2-docker-compose $DESTINATION
rm -rf $DESTINATION/.git
# set permission
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION
# config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
sudo sysctl -p
sed -i 's/10012/'$PORT'/g' $DESTINATION/docker-compose.yml
sed -i 's/20012/'$CHAT'/g' $DESTINATION/docker-compose.yml
# run Flectra
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo 'Started Flectra @ http://localhost:'$PORT' | Live chat port: '$CHAT