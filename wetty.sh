#!/usr/bin/env bash

chown term:term /home/term/sauron.sh

chown -R term:term /home/term/.ssh

chmod 400 /home/term/.ssh/id_rsa

echo '/bin/bash /home/term/sauron.sh' >> /home/term/.bashrc

service ssh start && node . --bypasshelmet --forcessh

while true
do
    tail -f /dev/null & wait ${!}
done
