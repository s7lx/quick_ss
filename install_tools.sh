#!/bin/bash
dirl=`pwd`
sudo ln -s $dirl/src/runss /usr/bin/runss
sudo ln -s $dirl/src/runall /usr/bin/runall
sudo ln -s $dirl/src/log_port /usr/bin/log_port
sudo ln -s $dirl/src/jsonwrite /usr/bin/jsonwrite
sudo ln -s $dirl/src/trafic_log /usr/bin/trafic_log

