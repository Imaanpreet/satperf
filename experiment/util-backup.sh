#!/bin/bash

source experiment/run-library.sh

inventory="${PARAM_inventory:-conf/contperf/inventory.ini}"
private_key="${PARAM_private_key:-conf/contperf/id_rsa_perf}"

wait_interval=${PARAM_wait_interval:-50}

opts="--forks 100 -i $inventory --private-key $private_key"
opts_adhoc="$opts --user root -e @conf/satperf.yaml -e @conf/satperf.local.yaml"


section "Checking environment"
generic_environment_check false
s $wait_interval


section "Backup"
a 00-backup.log satellite6 -m "shell" -a "rm -rf /root/backup /tmp/backup; mkdir /tmp/backup; satellite-maintain backup offline --skip-pulp-content /tmp/backup; mv /tmp/backup /root/"
