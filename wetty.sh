#!/usr/bin/env bash

chown term:term /home/term/sauron.sh

chown -R term:term /home/term/.ssh

service ssh start && node . --bypasshelmet --forcessh


while true
do
    tail -f /dev/null & wait ${!}
done
