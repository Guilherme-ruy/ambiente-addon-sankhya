# Praticar SQL no Oracle do laboratório

O banco deste laboratório é **Oracle Database 11g Express Edition (XE)**. Ele já contém a base-modelo do Sankhya. Para os exercícios iniciais, podemos usar o próprio esquema `SANKHYA`; não é necessário criar outro usuário nesta etapa.

As tabelas criadas nesse usuário passam a compartilhar o esquema usado pelo OM. Use nomes de exercício como `LAB_SQL_CLIENTES` para localizar seus objetos com facilidade. Alterar tabelas existentes do sistema pode afetar o funcionamento do OM, mesmo sendo um laboratório.

## Conectar

Inicie somente o banco conforme [RETOMADA.md](RETOMADA.md#estudar-apenas-oracle). No cliente SQL, configure:

| Campo | Valor |
| --- | --- |
| Tipo | Oracle |
| Host / porta | `localhost` / `1521` |
| Modo | SID |
| SID | `XE` |
| Usuário | `SANKHYA` |
| Senha inicial da imagem | `developer`, padrão público; use a sua se tiver alterado |

O serviço precisa estar saudável para aceitar a conexão. O WPM e o OM podem permanecer desligados durante exercícios SQL independentes.

## Conhecer a conexão e os objetos

```sql
SELECT USER AS usuario_atual, SYSDATE AS data_do_banco FROM dual;

SELECT table_name
FROM user_tables
WHERE ROWNUM <= 20;

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'LAB\_SQL\_%' ESCAPE '\'
ORDER BY object_type, object_name;
```

Os exemplos usam `ROWNUM`, disponível no Oracle 11g, para limitar a quantidade de linhas. Use material de SQL Oracle/PLSQL; exemplos de outros bancos podem ter diferenças de sintaxe.

## Primeiro exercício

Execute cada etapa separadamente no cliente SQL. Confira se o auto-commit do cliente está desligado antes de estudar `ROLLBACK`.

```sql
CREATE TABLE LAB_SQL_CLIENTES (
    ID NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    CADASTRO DATE DEFAULT SYSDATE
);

INSERT INTO LAB_SQL_CLIENTES (ID, NOME) VALUES (1, 'Cliente de estudo');
COMMIT;

SELECT ID, NOME, CADASTRO FROM LAB_SQL_CLIENTES;

UPDATE LAB_SQL_CLIENTES
SET NOME = 'Alteracao temporaria'
WHERE ID = 1;

SELECT ID, NOME FROM LAB_SQL_CLIENTES;
ROLLBACK;
SELECT ID, NOME FROM LAB_SQL_CLIENTES;
```

Depois do `ROLLBACK`, o nome volta ao valor confirmado anteriormente com `COMMIT`. Se repetir o exercício, a tabela já existirá e o ID 1 poderá estar gravado; adapte a etapa em vez de recriar objetos sem verificar.

## O que o rollback desfaz

`INSERT`, `UPDATE` e `DELETE` ainda não confirmados podem ser desfeitos com `ROLLBACK`. Comandos DDL, como `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE` e `TRUNCATE`, envolvem commits implícitos no Oracle; não conte com `ROLLBACK` para desfazer essas operações. Veja a [explicação da Oracle](https://blogs.oracle.com/sql/creating-multiple-tables-in-a-single-transaction).

Reiniciar o Docker também não desfaz operações já confirmadas. O volume preserva as alterações. Para limpar um exercício, revise e remova apenas seus objetos ou registros de estudo quando desejar. A [recriação completa da base](RETOMADA.md#reiniciar-e-recriar-a-base) é outra operação e pode exigir refazer a preparação do OM.

Os comandos deste guia foram preparados para estudo; não foram executados na base durante a organização dos arquivos em 12/11/2026.
