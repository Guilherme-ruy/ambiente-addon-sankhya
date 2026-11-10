# Andamento do ambiente

Registro em 10/11/2026. Este histórico descreve a instalação de referência que deu origem à distribuição pública.

## Etapas concluídas

- Limpeza do computador e remoção de resíduos do Docker Desktop e do Antigravity; VS Code preservado.
- Docker Engine, Compose e Buildx instalados dentro do Ubuntu/WSL 2. Teste `hello-world` aprovado.
- JDK 8 Linux x64 e WildFly 23 Sankhya instalados no sistema de arquivos Linux.
- Oracle 11g XE iniciado com persistência no diretório real da imagem, memória limitada e portas locais.
- WPM atualizado e OM 4.36b207 instalado; migrações iniciais executadas.
- Limites de RAM, processadores e swap do WSL aplicados e conferidos.
- VS Code conectado ao Ubuntu com extensões Java, depuração e Gradle; projeto configurado para JDK 8.

## Validações da instalação de referência

| Verificação | Resultado |
| --- | --- |
| Docker e Compose | Disponíveis; container de teste executado |
| Conexão Oracle com usuário do laboratório | Aprovada |
| Base após atualizações | 4.701 tabelas no esquema validado |
| Gerenciamento WildFly | Estado `running` |
| WPM e OM | Resposta HTTP 200; tela de acesso do OM exibida |
| Portas de aplicação, gerenciamento e debug | Restritas a loopback |
| Parada e início normais | Validados, inclusive após reinício do WSL |
| Licença e login autenticado no OM | Pendentes |
| Primeiro addon compilado e instalado | Pendente |

## Pendências para a mentoria

1. Obter licença de desenvolvimento/DEMO e configurar a ativação/SAS com orientação do mentor.
2. Validar o acesso autenticado e as telas necessárias no OM.
3. Revisar duas views inválidas da base-modelo: `RAT_ITENS` e `VW_TGFFIN_FRETERAT`. Ambas dependem de `AD_CTB.FUNC_DIVIDE`, ausente na base fornecida. Os objetos foram preservados para avaliação com mentor/DBA.
4. Gerar o template oficial do addon, compilar, implantar e testar a depuração de uma ação real.

A recompilação do esquema reduziu inicialmente 534 objetos inválidos para essas duas views. Depois das últimas migrações, outra recompilação voltou a deixá-las como as únicas duas pendências. O trigger `TRG_UPD_TFPEVE` foi verificado como válido. Nenhuma função financeira foi inventada para contornar a dependência ausente.

## Distribuição pública

Os arquivos desta pasta foram preparados separadamente do ambiente instalado. Não incluem senhas locais, licenças, pacotes comerciais, dados Oracle nem os registros pessoais da configuração. Os nomes de usuário e caminhos da máquina original não são necessários para reproduzir o roteiro.

A validação da distribuição portátil cobre sintaxe, configuração do Compose, instalador com os pacotes disponíveis em destino temporário e proteções contra substituição. Ela não equivale a uma segunda instalação completa do OM: essa etapa continua documentada a partir da instalação de referência.
