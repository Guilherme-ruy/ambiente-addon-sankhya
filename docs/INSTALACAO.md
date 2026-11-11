# Instalação no Ubuntu e WSL

## 1. Preparar o Ubuntu

No Windows, instale o WSL 2 com Ubuntu conforme a [documentação Microsoft](https://learn.microsoft.com/windows/wsl/install). Esta distribuição foi preparada para Ubuntu 24.04 x86_64. Confira no PowerShell com `wsl --list --verbose` e no Ubuntu com `cat /etc/os-release` e `uname -m`.

O Docker é instalado dentro do Ubuntu; Docker Desktop não é necessário. Evite manter dois Docker disputando a mesma integração WSL. Se já houver uma instalação, revise antes de alterar serviços ou remover dados.

No Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y git curl python3 unzip ca-certificates iproute2
mkdir -p ~/projects
```

Clone o repositório e entre na pasta:

```bash
cd ~/projects
git clone https://github.com/Guilherme-ruy/ambiente-addon-sankhya.git
cd ambiente-addon-sankhya
```

Se já tiver uma cópia, use essa pasta. Prefira o sistema de arquivos Linux para o projeto e para os SDKs, em vez de executar os arquivos no disco montado `/mnt/c`.

Para uma máquina com 16 GB de RAM, `examples/wslconfig.example` mostra os limites usados na instalação de referência: 6 GB de RAM, 6 processadores e 2 GB de swap. Mescle as opções necessárias com seu `%UserProfile%\.wslconfig`; não substitua uma configuração existente sem revisar. O limite vale para o WSL 2 inteiro. Para aplicar, pare as aplicações Linux e depois execute `wsl --shutdown` no PowerShell, reabrindo o Ubuntu em seguida. Ajuste conforme sua máquina.

## 2. Instalar Docker Engine e Compose

Dentro do Ubuntu, com systemd ativo:

```bash
bash scripts/install-docker.sh
```

O script usa o repositório oficial Docker e preserva instalações existentes. Ele informa se houver pacotes conflitantes. Feche e reabra a sessão Ubuntu após a instalação para aplicar o grupo `docker`.

```bash
docker version
docker compose version
docker run --rm hello-world
```

Se o serviço não estiver ativo: `sudo systemctl start docker`. Para configurar systemd no WSL, siga o [guia Microsoft](https://learn.microsoft.com/windows/wsl/systemd). O grupo `docker` concede poderes administrativos sobre o sistema Linux; adicione apenas seu usuário de desenvolvimento.

Referências: [instalação Docker no Ubuntu](https://docs.docker.com/engine/install/ubuntu/), [pós-instalação](https://docs.docker.com/engine/install/linux-postinstall/).

## 3. Instalar JDK e WildFly Sankhya

Baixe na [Central Sankhya](https://downloads.sankhya.com.br/) o JDK 8 Linux 64 bits e `Wildfly_23.0_Sankhya.zip`. Os nomes esperados e os termos de distribuição estão em [vendor/README.md](../vendor/README.md).

Se os downloads estiverem no Windows, copie somente esses dois arquivos para a pasta `vendor/` da cópia Linux. Não copie pastas de um servidor já configurado, credenciais ou licenças para este repositório.

```bash
cp .env.example .env
python3 scripts/install-sdk.py \
  --jdk vendor/jdk-8u421-linux-x64.tar.gz \
  --wildfly vendor/Wildfly_23.0_Sankhya.zip
```

O instalador requer Python 3.12+, extrai em `$HOME/sankhya-sdk/jdk8` e `$HOME/sankhya-sdk/wildfly`, verifica Java 8 e presença do WPM e recusa substituir diretórios existentes. Ele reduz `-Xms2048m` para `-Xms512m`, preservando o máximo de 2 GB de heap e uma cópia original de `standalone.conf`. O teto de metaspace do pacote continua em 2 GB: heap máximo não representa a memória total do processo Java.

Para outro destino, passe `--destination /caminho/linux/sdk` e ajuste `SANKHYA_SDK_HOME` em `.env` para o mesmo caminho absoluto. O arquivo `.env` é carregado como configuração Bash; use apenas conteúdo local confiável e não o envie ao GitHub.

## 4. Configurar o WPM e instalar o OM

```bash
bash scripts/start.sh
```

O Compose baixa a imagem e importa o banco na primeira execução. O WildFly fica em primeiro plano, mantendo a sessão WSL ativa. Use outro terminal para `docker compose logs -f db` ou `bash scripts/status.sh`. A primeira instalação e a migração dos módulos podem levar bastante tempo; aguarde os registros de conclusão antes de interromper o processo.

Acesse `http://localhost:8080/wpm/WebPkgMan.xhtml5`. No primeiro acesso, utilize a senha inicial informada pelo fornecedor e defina uma senha própria quando solicitado. Não registre a nova senha na documentação nem no Git.

No WPM, configure:

| Campo | Valor da base de demonstração |
| --- | --- |
| Tipo | Oracle |
| Servidor / porta | `127.0.0.1` / `1521` |
| SID | `XE` |
| Usuário | `SANKHYA` |
| Senha padrão pública da imagem | `developer` |
| URL JDBC equivalente | `jdbc:oracle:thin:@127.0.0.1:1521/XE` |

Esses valores do banco são padrões publicados no [guia Sankhya](https://developer.sankhya.com.br/docs/01_ambiente), não credenciais pessoais. Não use esta base de demonstração para dados de produção.

Teste a conexão, selecione a versão OM indicada pela mentoria no WPM e instale os módulos necessários. Na instalação de referência, foi selecionada a versão estável disponível, 4.36b207. O WPM cria o datasource `java:/MGEDS`; preserve o arquivo gerado fora deste repositório, pois ele pode conter a senha do banco.

Depois da instalação, confira `http://localhost:8080/mge/`. Solicite ao mentor uma licença de desenvolvimento/DEMO e siga o [roteiro de ativação](ATIVACAO.md). A tela de login e uma resposta HTTP 200 não comprovam uso autenticado. Na instalação de referência, a chave foi aplicada e o acesso autenticado foi validado em 11/11/2026.

### Persistência do Oracle

A imagem `1.1.0` usa `/u01/app/oracle/oradata`, caminho observado nos metadados e na inicialização da imagem testada. Por isso o Compose monta o volume nesse local. O comando atualmente mostrado pelo guia Sankhya usa `/opt/oracle/oradata`; essa diferença foi ajustada para a imagem validada. Reconfira antes de trocar a imagem:

```bash
docker image inspect sankhyaimages/skdev-oracle:1.1.0 --format '{{json .Config.Volumes}}'
docker compose config
```

O nome do volume desta distribuição é próprio do projeto Compose. Não reaproveite automaticamente volumes de outro laboratório e não use `down -v` para parar o ambiente.

## 5. Desenvolver e depurar addons

Crie uma solução e um componente addon na [Área do Desenvolvedor Sankhya](https://areadev.sankhya.com.br/) e obtenha o template oficial. Extraia em uma pasta de projeto separada. Use seu `gradlew` e as versões do template; este repositório prepara a infraestrutura e não substitui o template do addon.

No VS Code para Windows, instale a extensão WSL e abra o projeto dentro do Ubuntu. No contexto remoto, instale as extensões Java, Debugger for Java e Gradle. Configure o runtime do projeto e o Gradle para `$HOME/sankhya-sdk/jdk8`. O Java usado internamente pela extensão pode ser diferente do JDK 8 do projeto.

Para compilar em um terminal Ubuntu:

```bash
export JAVA_HOME="$HOME/sankhya-sdk/jdk8"
export PATH="$JAVA_HOME/bin:$PATH"
java -version
javac -version
```

Depois execute as tarefas do Gradle Wrapper indicadas pelo template. Copie `examples/launch.json` para `.vscode/launch.json` do addon e conecte ao WildFly local na porta 8787. Faça o deploy conforme o template e a mentoria. Compilação, deploy e execução do primeiro addon ainda precisam ser validados após a ativação do OM.

## 6. Parar e verificar

Em outro terminal, nesta pasta:

```bash
bash scripts/status.sh
bash scripts/stop.sh
```

A parada usa a CLI local do WildFly antes de parar o banco. Se o servidor não encerrar normalmente, o script preserva o banco ativo e informa o problema. Não encerre o WSL enquanto houver operações de atualização ou importação.

O Compose limita os logs do container a três arquivos de 10 MB. Logs do WildFly continuam no SDK e precisam de acompanhamento; nunca os copie automaticamente para o repositório público.
