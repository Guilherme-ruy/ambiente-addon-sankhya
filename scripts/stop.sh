#!/usr/bin/env bash
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
if ss -H -ltn 'sport = :9990' | grep -q .; then
  [[ -x "$WILDFLY_HOME/bin/jboss-cli.sh" ]] || { echo 'CLI do WildFly não encontrada; banco mantido ativo.' >&2; exit 1; }
  "$WILDFLY_HOME/bin/jboss-cli.sh" --connect --controller=127.0.0.1:9990 --command=:shutdown
  for ((attempt=0; attempt<120; attempt++)); do
    if ! ss -H -ltn 'sport = :9990' | grep -q . && ! ss -H -ltn 'sport = :8080' | grep -q .; then
      break
    fi
    sleep 1
  done
fi
if ss -H -ltn 'sport = :8080' | grep -q . || ss -H -ltn 'sport = :9990' | grep -q .; then
  echo 'Servidor ainda está ativo. Banco mantido ligado para preservar a parada normal.' >&2
  exit 1
fi
compose stop db
echo 'Ambiente parado. Volume do banco preservado.'
