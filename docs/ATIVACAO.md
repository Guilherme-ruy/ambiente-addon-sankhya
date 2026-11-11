# Ativação da licença e primeiro acesso

Cada pessoa precisa obter uma chave de cliente autorizada para seu laboratório. A licença usada na instalação de referência não acompanha este repositório. Guarde sua chave em arquivo local não versionado, de preferência fora da pasta do projeto.

## Primeiro acesso ao OM

Inicie o ambiente e abra `http://localhost:8080/mge/`. Entre com o usuário inicial fornecido com a base-modelo. Se o sistema solicitar troca de senha, conclua essa etapa pessoalmente no navegador. A senha do OM é independente da senha do WPM; não registre nenhuma delas nos arquivos públicos.

O aviso `LU0103` indica chave de cliente ausente ou inválida. Na instalação de referência, foi possível fechar o aviso, concluir a troca obrigatória de senha e abrir a administração para aplicar a chave.

## Aplicar a chave

1. Na pesquisa do OM, abra **Administração do Servidor**, em **Configurações > Avançado**.
2. Selecione a aba **Licença**.
3. Confira o status do SAS. Na instalação de referência, o SAS 4.8.0 já veio com o OM e apareceu como **Conectado**, sem instalação separada de outro serviço.
4. Informe sua chave no campo **Chave de Cliente** e clique em **Aplicar**.
5. Aguarde a confirmação e confira se os dados do licenciado e os produtos foram carregados.
6. Use **Recarregar Licença** e confirme a mensagem de atualização bem-sucedida.
7. Abra **Add-ons Instalados** para conferir o acesso autenticado. A lista vazia é esperada antes do primeiro deploy.

Se o SAS estiver desconectado, ou a chave não for aceita, siga a mensagem exibida e consulte o mentor. Os modos de licenciamento variam conforme a versão e o contrato; não reutilize automaticamente configurações de produção nem altere parâmetros sem confirmar sua aplicação ao laboratório.

## Proteção das informações

O `.gitignore` exclui `.env`, chaves, licenças e arquivos como `chave*.txt` ou `licenca*.txt`. Essa proteção não retira um arquivo que já tenha sido versionado. Revise o conteúdo a enviar antes de cada commit e não use `git add -f` para incluir esses arquivos.

Capturas da aba Licença podem mostrar a chave, identificadores e dados das empresas licenciadas. Mantenha essas capturas fora da distribuição pública. Para documentar o sucesso, prefira uma mensagem de confirmação sobre uma tela que não exiba esses dados.

## Validação da instalação de referência

Em 11/11/2026, a chave foi aplicada pela interface oficial, o SAS permaneceu conectado após a recarga e o OM confirmou a atualização da licença. O acesso autenticado à administração e à tela de addons foi validado. A execução de um addon e os demais fluxos de negócio ainda precisam de testes próprios.

Referência: [Administração do Servidor — aba Licença](https://ajuda.sankhya.com.br/hc/pt-br/articles/360045107833-Administra%C3%A7%C3%A3o-do-Servidor).
