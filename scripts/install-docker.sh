#!/usr/bin/env bash
set -euo pipefail
source /etc/os-release
[[ "$ID" == ubuntu && "${VERSION_ID:-}" == 24.04 && "$(uname -m)" == x86_64 ]] || {
  echo 'Instalador preparado para Ubuntu 24.04 x86_64. Para outras versões, consulte a documentação Docker.' >&2; exit 1;
}
if command -v docker >/dev/null 2>&1; then
  echo 'Docker já encontrado. Confira docker version e docker compose version; instalação preservada.'
  exit 0
fi
for package in docker.io docker-compose docker-compose-v2 podman-docker containerd runc; do
  if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
    echo "Pacote conflitante: $package. Revise a instalação conforme a documentação Docker antes de continuar." >&2
    exit 1
  fi
done
sudo apt-get update
sudo apt-get install -y ca-certificates curl python3 git unzip iproute2
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
printf 'Types: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: %s\nComponents: stable\nArchitectures: %s\nSigned-By: /etc/apt/keyrings/docker.asc\n' "${UBUNTU_CODENAME:-$VERSION_CODENAME}" "$(dpkg --print-architecture)" | sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$(id -un)"
echo 'Docker instalado. Feche e reabra a sessão Ubuntu para aplicar o grupo docker.'
