#!/bin/bash
dirl=`pwd`
sudo ln -f -s $dirl/src/runss /usr/bin/runss
sudo ln -f -s $dirl/src/runall /usr/bin/runall
sudo ln -f -s $dirl/src/runall_ex /usr/bin/runall_ex
sudo ln -f -s $dirl/src/log_port /usr/bin/log_port
sudo ln -f -s $dirl/src/jsonwrite /usr/bin/jsonwrite
sudo ln -f -s $dirl/src/trafic_log /usr/bin/trafic_log
sudo ln -f -s $dirl/src/regex /usr/bin/regex
sudo ln -f -s $dirl/src/asgeo /usr/bin/asgeo
sudo ln -f -s $dirl/src/netnow /usr/bin/netnow
sudo ln -f -s $dirl/src/read_pass /usr/bin/read_pass
sudo ln -f -s $dirl/src/ss_watch_dog /usr/bin/ss_watch_dog
sudo ln -f -s $dirl/src/ss_tpl.tpl /etc/ss_tpl.tpl
sudo ln -f -s $dirl/src/ss_tpl_cpt.tpl /etc/ss_tpl_cpt.tpl
sudo ln -f -s $dirl/src/restore_ss /usr/bin/restore_ss
sudo ln -f -s $dirl/src/upgrade_ss /usr/bin/upgrade_ss
sudo ln -f -s $dirl/src/upgrade_all /usr/bin/upgrade_all
sudo ln -f -s $dirl/src/forward_ss /usr/bin/forward_ss
sudo ln -f -s $dirl/src/susp_ss /usr/bin/susp_ss
sudo ln -f -s $dirl/src/check_conn /usr/bin/check_conn
sudo ln -f -s $dirl/src/re_run_all /usr/bin/re_run_all
sudo ln -f -s $dirl/src/backup_dir.sh /usr/bin/backup_dir.sh