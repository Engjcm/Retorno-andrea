# Volta da Andréa — GitHub Pages + Supabase

Este projeto é um site estático (HTML, CSS e JavaScript) preparado para hospedagem no GitHub Pages. O visual original foi preservado e o mural foi migrado da API `window.claude` para o Supabase.

## Arquivos

- `index.html`: site completo.
- `supabase-schema.sql`: tabelas, políticas de segurança (RLS) e permissões do banco.

## 1. Criar e configurar o Supabase

1. Crie um projeto em https://supabase.com.
2. Abra **SQL Editor** no painel do Supabase.
3. Abra o arquivo `supabase-schema.sql`, copie todo o conteúdo e execute no SQL Editor.
4. Em **Project Settings → API**, copie:
   - **Project URL**
   - **anon / publishable key** (chave pública; dependendo da versão do painel, pode aparecer como `anon`).
5. No `index.html`, procure no início do JavaScript por:

   ```js
   const SUPABASE_URL = "COLE_AQUI_A_URL_DO_SEU_PROJETO";
   const SUPABASE_ANON_KEY = "COLE_AQUI_SUA_CHAVE_ANON_PUBLIC";
   ```

6. Substitua os dois valores pelos dados do seu projeto.

**Importante:** nunca use a chave `service_role` no HTML, no GitHub ou em qualquer código executado no navegador. A chave pública/anon é apropriada para o frontend somente porque o banco está protegido pelas políticas RLS incluídas no SQL.

## 2. Criar o acesso administrativo

A exclusão de recados é restrita a usuários cadastrados na tabela `administradores`.

1. No Supabase, abra **Authentication → Users**.
2. Crie um usuário administrador (e-mail e senha).
3. Copie o UUID desse usuário.
4. No SQL Editor, execute, substituindo o UUID:

   ```sql
   insert into public.administradores (user_id)
   values ('UUID-DO-USUARIO-AQUI');
   ```

5. No site, abra **Acesso administrativo**, informe o e-mail e a senha desse usuário e entre.
6. Apenas essa conta cadastrada poderá remover recados. Para sair, use **Sair**.

Não compartilhe a senha administrativa. Não cadastre usuários comuns na tabela `administradores`.

## 3. Publicar no GitHub Pages

1. Crie um repositório no GitHub, por exemplo `volta-andrea`.
2. Envie `index.html` para a raiz do repositório. O nome precisa ser exatamente `index.html`.
3. Em **Settings → Pages**, escolha **Deploy from a branch**.
4. Selecione a branch `main` e a pasta `/ (root)`, depois salve.
5. Aguarde a publicação. O endereço será semelhante a `https://SEU-USUARIO.github.io/volta-andrea/`.

O projeto não precisa de Node, npm, build ou framework.

## 4. Testes depois da publicação

- Abra o site por HTTPS.
- Teste em janela anônima: os recados devem carregar e um visitante deve conseguir publicar.
- Abra o site em outro navegador/dispositivo: os mesmos recados devem aparecer.
- Teste o tema automático mudando a preferência claro/escuro do sistema operacional.
- Entre com o usuário administrador e teste a remoção de um recado.
- Confira o console do navegador (F12 → Console) se algo falhar.

## 5. Observações importantes

- O tema acompanha automaticamente a preferência de aparência do dispositivo. Não há botão manual de tema nesta versão, conforme solicitado.
- A contagem regressiva está configurada para **18/11/2026 às 08:00 (horário de Brasília, UTC−3)**. Para alterar a data, edite `TARGET` no JavaScript e os textos correspondentes no HTML.
- O mural usa Supabase Realtime. No painel Supabase, confirme que `public.recados` está habilitada na publicação `supabase_realtime` (Database → Publications).
- As políticas permitem leitura e envio público de recados; somente administradores cadastrados podem excluir. Para um mural público, considere adicionar CAPTCHA/limite anti-spam antes de divulgar amplamente.
- O GitHub Pages hospeda arquivos estáticos; os dados ficam no Supabase.

## Solução de problemas

**O site abre, mas o mural diz que falta conectar o Supabase:** confira se URL e chave pública foram preenchidas corretamente no `index.html`.

**Erro de permissão / RLS:** execute novamente o `supabase-schema.sql` no SQL Editor e confira se as políticas da tabela `recados` estão habilitadas.

**Os recados aparecem, mas não atualizam em tempo real:** habilite `public.recados` na publicação `supabase_realtime`.

**A página retorna 404:** confirme que o arquivo se chama exatamente `index.html` e está na pasta selecionada em Settings → Pages.
