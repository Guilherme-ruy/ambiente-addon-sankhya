# Retomar o laboratório sem o histórico do chat

Este documento é o ponto de revisão para quem volta ao ambiente depois de algum tempo. Para uma primeira instalação, use [INSTALACAO.md](INSTALACAO.md). Para o estado validado e as pendências, leia [ANDAMENTO.md](ANDAMENTO.md).

## O que roda onde

| Componente | Local |
| --- | --- |
| Oracle Database 11g XE | Container Docker no Ubuntu |
| Dados Oracle | Volume persistente do Compose |
| JDK 8 e WildFly Sankhya | Sistema de arquivos do Ubuntu |
| Pacotes OM | Instalados pelo WPM no WildFly |
| Projeto addon | Projeto separado, criado a partir do template oficial |

O usuário `SANKHYA` é do Oracle. O usuário do OM e o login do WPM são acessos independentes. A chave de cliente ativa o licenciamento; ela não é uma senha de conexão SQL.

## Estudar apenas Oracle

No terminal Ubuntu, dentro do repositório:

```bash
bash scripts/start-db.sh
```

Esse comando solicita apenas o banco. Não inicia o WildFly e não desliga um WildFly já existente. Conecte seu cliente SQL em `localhost:1521`, SID `XE`, usuário `SANKHYA`. A senha original da base-modelo é o padrão público `developer`, salvo se você a tiver alterado.

No WSL, mantenha o terminal Ubuntu aberto durante o uso do banco para preservar a sessão da distribuição.

Para estudar, siga [ORACLE-PRATICA.md](ORACLE-PRATICA.md). O modo com apenas o banco reduz o consumo em relação a executar também o OM.

## Usar o ambiente completo

```bash
bash scripts/start.sh
```

Mantenha esse terminal aberto. Use outro terminal para `bash scripts/status.sh`. A inicialização completa pode levar vários minutos; evite interromper importações ou migrações.

Abra o [OM](http://localhost:8080/mge/) e confira o acesso autenticado. Se for uma instalação nova, conclua o [licenciamento](ATIVACAO.md) com sua própria chave. Antes do primeiro addon, obtenha o template no portal oficial e use seu Gradle Wrapper.

## Encerrar

Em outro terminal, dentro do repositório:

```bash
bash scripts/stop.sh
```

O script encerra normalmente o WildFly, quando ativo, e para o banco, mantendo os dados. No WSL, fechar o servidor pode não encerrar imediatamente toda a distribuição. Para liberar os recursos da distribuição, feche seus outros trabalhos nela e encerre somente a distribuição correspondente pelo Windows; `wsl --terminate Ubuntu` se ela realmente se chamar `Ubuntu`. Outras distribuições devem ser preservadas.

## Reiniciar e recriar a base

| Operação | Efeito nos dados Oracle |
| --- | --- |
| Parar/iniciar ou reiniciar o container | Dados e exercícios permanecem |
| Remover o container e usar novamente o mesmo volume | Dados permanecem |
| `docker compose down`, sem `-v` | O volume nomeado permanece |
| `docker compose down -v` | Remove o volume do projeto e perde seus dados |
| Apagar somente a imagem Docker | Não restaura o conteúdo de um volume existente |

Os comportamentos de [restart](https://docs.docker.com/reference/cli/docker/compose/restart/) e [down](https://docs.docker.com/reference/cli/docker/compose/down/) estão descritos na documentação Docker.

Para refazer uma base danificada, identifique primeiro o projeto Compose e seu volume, pare o servidor e o banco e preserve qualquer estado que deseje recuperar. Depois, a recriação deve atuar apenas nos recursos desse laboratório. Não é necessário limpar todo o Docker para reiniciar um exercício.

Após perder o volume, a imagem importa novamente sua base inicial. **Isso não equivale ao banco após nossa instalação do OM.** Será necessário revisar WPM, atualizações/migrações, usuários, preferências e licenciamento. O JDK, o WildFly e seus arquivos nativos continuam no Ubuntu, portanto é importante manter a aplicação e o banco compatíveis.

Não há um reset destrutivo automático neste kit. As verificações já feitas também não representam um backup completo recuperável. Para recuperação exata, prepare e valide um backup adequado antes de descartar o volume.

## Antes de publicar alterações

Somente scripts e documentação revisados devem ir ao GitHub. Chaves, licenças, `.env`, dados Oracle, logs e pacotes de fornecedores permanecem locais. Consulte [PUBLICACAO.md](PUBLICACAO.md).
