#!/usr/bin/env bash
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
compose ps --all
for endpoint in 'http://localhost:8080/wpm/WebPkgMan.xhtml5' 'http://localhost:8080/mge/'; do
  if ! code="$(curl --silent --output /dev/null --write-out '%{http_code}' --max-time 10 "$endpoint")"; then
    code='indisponível'
  fi
  printf '%s -> %s\n' "$endpoint" "$code"
done
echo 'HTTP 200 confirma a resposta da página; não confirma licença nem login.'
