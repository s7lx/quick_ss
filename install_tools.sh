#!/bin/bash
dirl=`pwd`
sudo ln -f -s $dirl/src/runss /usr/bin/runss
sudo ln -f -s $dirl/src/runall /usr/bin/runall
sudo ln -f -s $dirl/src/log_port /usr/bin/log_port
sudo ln -f -s $dirl/src/jsonwrite /usr/bin/jsonwrite
sudo ln -f -s $dirl/src/trafic_log /usr/bin/trafic_log

