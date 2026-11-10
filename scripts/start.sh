#!/usr/bin/env bash
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
[[ -x "$JAVA_HOME/bin/java" && -x "$JAVA_HOME/bin/javac" ]] || { echo 'Instale o JDK Linux 8: veja docs/INSTALACAO.md.' >&2; exit 1; }
[[ -x "$WILDFLY_HOME/bin/standalone.sh" ]] || { echo 'Instale o WildFly Sankhya: veja docs/INSTALACAO.md.' >&2; exit 1; }
"$JAVA_HOME/bin/java" -version 2>&1 | grep -q 'version "1.8\.' || { echo 'Este ambiente requer JDK 8.' >&2; exit 1; }
for port in 8080 8787 9990; do
  if ss -H -ltn "sport = :$port" | grep -q .; then
    echo "Porta $port ocupada. Verifique o ambiente existente antes de iniciar outra instância." >&2
    exit 1
  fi
done
bash "$LAB_ROOT/scripts/start-db.sh"
cd -- "$WILDFLY_HOME/bin"
# O terminal aberto mantém o processo do servidor e a sessão WSL ativos.
exec ./standalone.sh --debug 127.0.0.1:8787 -b 127.0.0.1 -bmanagement 127.0.0.1
