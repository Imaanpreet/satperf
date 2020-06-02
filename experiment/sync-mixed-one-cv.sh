#!/bin/bash

source experiment/run-library.sh

manifest="${PARAM_manifest:-conf/contperf/manifest.zip}"
inventory="${PARAM_inventory:-conf/contperf/inventory.ini}"
private_key="${PARAM_private_key:-conf/contperf/id_rsa_perf}"

test_sync_mixed_count="${PARAM_test_sync_mixed_count:-8}"
test_sync_mixed_max_sync_secs="${PARAM_test_sync_mixed_max_sync_secs:-1200}"
test_sync_docker_url_template="${PARAM_test_sync_docker_url_template:-https://registry-1.docker.io}"
test_sync_repositories_url_template="${PARAM_test_sync_repositories_url_template:-http://repos.example.com/repo*}"
test_sync_iso_url_template="${PARAM_test_sync_iso_url_template:-http://storage.example.com/iso-repos*}"

wait_interval=${PARAM_wait_interval:-50}

cdn_url_mirror="${PARAM_cdn_url_mirror:-https://cdn.redhat.com/}"
cdn_url_full="${PARAM_cdn_url_full:-https://cdn.redhat.com/}"

PARAM_docker_registry=${PARAM_docker_registry:-https://registry-1.docker.io/}
PARAM_iso_repos=${PARAM_iso_repos:-http://storage.example.com/iso-repos/}
repo_sat_tools="${PARAM_repo_sat_tools:-http://mirror.example.com/Satellite_Tools_x86_64/}"

do="Default Organization"
dl="Default Location"

opts="--forks 100 -i $inventory --private-key $private_key"
opts_adhoc="$opts --user root -e @conf/satperf.yaml -e @conf/satperf.local.yaml"

section "Checking environment"
generic_environment_check

section "Sync mixed repo"
ap 10-test-sync-mixed.log playbooks/tests/sync-mixed-repos-one-cvs.yaml -e "test_sync_mixed_count=$test_sync_mixed_count test_sync_repositories_url_template=$test_sync_repositories_url_template test_sync_iso_url_template=$test_sync_iso_url_template test_sync_docker_url_template=$test_sync_docker_url_template test_sync_mixed_max_sync_secs=$test_sync_mixed_max_sync_secs"

section "Summary"
e SyncRepositoriesYum $logs/10-test-sync-mixed.log
e SyncRepositoriesDocker $logs/10-test-sync-mixed.log
e SyncRepositoriesISO $logs/10-test-sync-mixed.log
e PublishContentViews $logs/10-test-sync-mixed.log
e PromoteContentViews $logs/10-test-sync-mixed.log

junit_upload
