# Publicação no GitHub

Nome sugerido: **ambiente-addon-sankhya**. Visibilidade pública para compartilhar os scripts e a documentação de preparação do laboratório.

## Arquivos distribuídos

- `README.md`, `LICENSE`, `.gitignore` e `.gitattributes`.
- `compose.yaml` e `.env.example`, sem valores pessoais.
- `scripts/`: instalação e operação local.
- `docs/`: instalação, andamento e este roteiro.
- `examples/`: limites WSL e depuração Java.
- `vendor/README.md`: como obter os pacotes oficiais.

A pasta original do computador não deve ser a raiz desse repositório. Ela contém downloads, históricos, logs e arquivos de operação pessoais. Apenas esta pasta separada é destinada à publicação.

## Revisão antes do envio

Confira `git status --short` e `git diff --cached` antes de cada commit. O `.gitignore` não remove um segredo que já tenha sido versionado e não substitui essa revisão. Arquivos locais com senha, tokens, chave de licença, URLs assinadas, dumps ou dados de cliente devem permanecer fora do histórico.

JDK, WildFly/WPM e OM são obtidos pelos canais oficiais por quem usar o laboratório. O Java deste pacote usa a licença Oracle OTN, que restringe a redistribuição. O WildFly original é aberto; a distribuição Sankhya inclui componentes adicionais. O projeto não atribui a licença MIT a esses produtos.

Os dois arquivos baixados também ultrapassam o limite de 100 MiB por arquivo do Git comum no GitHub. Git LFS não resolve permissões de redistribuição e não é necessário para esta distribuição.

Depois da criação do repositório pessoal vazio, o envio pode ser feito pelo Git local, selecionando apenas os arquivos descritos acima. A criação e o envio precisam usar sua conta autenticada. Não publique `.env`, nem substitua o exemplo por um arquivo de servidor existente.

## Referências

- [Repositórios públicos e privados](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories).
- [Limites de arquivos no GitHub](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github).
- [Licença Oracle Java OTN](https://www.oracle.com/downloads/licenses/javase-license1.html).
- [Sobre o WildFly original](https://www.wildfly.org/about/).
