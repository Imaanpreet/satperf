#!/bin/bash

source experiment/run-library.sh

manifest="${PARAM_manifest:-conf/contperf/manifest.zip}"
inventory="${PARAM_inventory:-conf/contperf/inventory.ini}"
private_key="${PARAM_private_key:-conf/contperf/id_rsa_perf}"

wait_interval=${PARAM_wait_interval:-50}

cdn_url_mirror="${PARAM_cdn_url_mirror:-https://cdn.redhat.com/}"
cdn_url_full="${PARAM_cdn_url_full:-https://cdn.redhat.com/}"

PARAM_docker_registry=${PARAM_docker_registry:-https://registry-1.docker.io/}

do="Default Organization"
dl="Default Location"

opts="--forks 100 -i $inventory --private-key $private_key"
opts_adhoc="$opts --user root -e @conf/satperf.yaml -e @conf/satperf.local.yaml"


section "Checking environment"
generic_environment_check

section "Sync file repo"
ap 10-test-sync-repositories.log playbooks/tests/sync-docker.yaml -e "test_sync_repositories_count=$test_sync_repositories_count test_sync_repositories_url_template=$test_sync_repositories_url_template test_sync_repositories_max_sync_secs=$test_sync_repositories_max_sync_secs"

section "Summary"
e SyncRepositories $logs/10-test-sync-repositories.log
e PublishContentViews $logs/10-test-sync-repositories.log
e PromoteContentViews $logs/10-test-sync-repositories.log

junit_upload
~
