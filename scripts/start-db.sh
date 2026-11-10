#!/usr/bin/env bash
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
docker info >/dev/null
compose up -d --wait --wait-timeout "${DB_WAIT_SECONDS:-2400}" db
compose ps
