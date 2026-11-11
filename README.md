# Ambiente addon Sankhya

Laboratório de desenvolvimento Sankhya OM em **Ubuntu 24.04 x86_64**, no Linux ou no **WSL 2**. Usa Docker Engine e Compose para o Oracle, com JDK 8 e WildFly Sankhya executados diretamente no Ubuntu.

O objetivo é reproduzir a preparação da mentoria seguindo o [guia oficial Sankhya](https://developer.sankhya.com.br/docs/01_ambiente). Projeto comunitário, sem vínculo oficial com a Sankhya. Destinado ao desenvolvimento local.

## Situação atual

Em 11/11/2026, a instalação de referência está com **licença aplicada, SAS conectado e acesso autenticado ao OM validado**. A tela de addons instalados foi aberta com sucesso. Oracle, WPM e reinicialização já foram validados. O primeiro addon ainda será criado, compilado e implantado.

Veja o [andamento e as pendências](docs/ANDAMENTO.md) e o [roteiro de ativação](docs/ATIVACAO.md). Os scripts desta distribuição foram derivados do ambiente funcionando e têm suas verificações descritas nesse registro.

## Componentes

| Componente | Referência validada |
| --- | --- |
| Ubuntu | 24.04.4 LTS, WSL 2 |
| Docker Engine / Compose | 29.9.3 / 5.7.0 |
| Oracle | `sankhyaimages/skdev-oracle:1.1.0`, 11g XE |
| JDK / javac | 1.8.0_421, Linux x64 |
| WildFly Sankhya | Full 23.0.1.Final, pacote 23.0 |
| WPM / OM | 9.0 build 559 / 4.36b207 |

As versões do WPM e do OM podem mudar quando instaladas pelos canais oficiais. O OM é instalado pelo WPM; não está empacotado aqui.

## Preparação

Tenha aproximadamente 16 GB de RAM na máquina, SSD com espaço disponível, acesso aos downloads Sankhya e uma licença de desenvolvimento para concluir a ativação. O guia oficial recomenda SSD de 120 GB ou mais. Reserve várias horas para downloads, importação da base e atualizações.

1. Siga [Instalação no Ubuntu/WSL](docs/INSTALACAO.md) para instalar os pré-requisitos.
2. Obtenha os dois arquivos oficiais e coloque em `vendor/`, conforme [orientações dos downloads](vendor/README.md).
3. No terminal Ubuntu, dentro desta pasta:

```bash
cp .env.example .env
python3 scripts/install-sdk.py \
  --jdk vendor/jdk-8u421-linux-x64.tar.gz \
  --wildfly vendor/Wildfly_23.0_Sankhya.zip
bash scripts/start.sh
```

Mantenha esse terminal aberto. O banco será preparado antes de o WildFly iniciar. Na primeira vez, a importação pode demorar mais de 30 minutos; o limite inicial é 40 minutos, ajustável em `.env`.

4. Abra o [WPM local](http://localhost:8080/wpm/WebPkgMan.xhtml5), defina sua senha, configure a conexão e instale o OM conforme [o passo a passo](docs/INSTALACAO.md#4-configurar-o-wpm-e-instalar-o-om).
5. Obtenha a licença e crie o projeto addon pelo portal oficial. Use o Gradle Wrapper do template.

## Uso diário

```bash
bash scripts/start.sh    # Banco + WildFly em primeiro plano
# Em outro terminal Ubuntu, dentro do repositório:
bash scripts/status.sh
bash scripts/stop.sh     # Parada normal, preservando os dados
```

| Serviço | Endereço local |
| --- | --- |
| Sankhya OM | http://localhost:8080/mge/ |
| WPM HTML5 | http://localhost:8080/wpm/WebPkgMan.xhtml5 |
| Oracle | `localhost:1521`, SID `XE` |
| Debug Java | `localhost:8787` |
| Gerenciamento WildFly | `localhost:9990` |

O banco persiste no volume `<projeto>_oracle-data`. O projeto padrão é `ambiente-addon-sankhya`. **`docker compose down -v` apaga os dados desse volume.** Não execute os scripts junto de outro laboratório usando as mesmas portas. Não há inicialização automática com o Windows.

## Conteúdo público

Documentação, scripts, Compose e exemplos sem credenciais pessoais. JDK, pacote WildFly/WPM, OM, licenças, base de dados, logs e `.env` ficam fora do Git. Existem senhas no ambiente instalado; elas não são copiadas para esta distribuição.

As credenciais padrão do banco de demonstração estão descritas no guia de instalação e na documentação oficial do fornecedor. Esses padrões tornam este laboratório inadequado para exposição na internet.

Veja [publicação e revisão](docs/PUBLICACAO.md). A [licença MIT](LICENSE) cobre apenas os scripts e a documentação deste projeto; os produtos de terceiros mantêm seus próprios termos.
