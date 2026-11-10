#!/usr/bin/env bash
set -euo pipefail
LAB_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$LAB_ROOT/.env" ]]; then
  set -a
  source "$LAB_ROOT/.env"
  set +a
fi
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-ambiente-addon-sankhya}"
export SANKHYA_SDK_HOME="${SANKHYA_SDK_HOME:-$HOME/sankhya-sdk}"
export JAVA_HOME="$SANKHYA_SDK_HOME/jdk8"
export WILDFLY_HOME="$SANKHYA_SDK_HOME/wildfly"
export PATH="$JAVA_HOME/bin:$PATH"
compose() {
  if [[ -f "$LAB_ROOT/.env" ]]; then
    docker compose --project-directory "$LAB_ROOT" --env-file "$LAB_ROOT/.env" -f "$LAB_ROOT/compose.yaml" "$@"
  else
    docker compose --project-directory "$LAB_ROOT" -f "$LAB_ROOT/compose.yaml" "$@"
  fi
}
