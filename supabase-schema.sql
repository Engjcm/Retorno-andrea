-- Volta da Andréa: estrutura do banco Supabase
-- Execute este arquivo no SQL Editor do seu projeto Supabase.

create extension if not exists pgcrypto;

create table if not exists public.recados (
  id uuid primary key default gen_random_uuid(),
  nome varchar(40) not null default 'Alguém do time',
  texto varchar(280) not null check (char_length(trim(texto)) between 1 and 280),
  cor smallint not null default 1 check (cor between 1 and 4),
  criado_em timestamptz not null default now()
);

create table if not exists public.administradores (
  user_id uuid primary key references auth.users(id) on delete cascade,
  criado_em timestamptz not null default now()
);

alter table public.recados enable row level security;
alter table public.administradores enable row level security;

-- Visitantes podem ler recados e publicar novos recados.
drop policy if exists "Recados visíveis para todos" on public.recados;
create policy "Recados visíveis para todos"
on public.recados for select
to anon, authenticated
using (true);

drop policy if exists "Visitantes podem publicar recados" on public.recados;
create policy "Visitantes podem publicar recados"
on public.recados for insert
to anon, authenticated
with check (
  char_length(trim(texto)) between 1 and 280
  and char_length(nome) <= 40
  and cor between 1 and 4
);

-- Usuários autenticados só conseguem ver seu próprio vínculo administrativo.
drop policy if exists "Administrador consulta seu próprio cadastro" on public.administradores;
create policy "Administrador consulta seu próprio cadastro"
on public.administradores for select
to authenticated
using (user_id = auth.uid());

-- Somente usuários cadastrados em administradores podem excluir recados.
drop policy if exists "Somente administradores removem recados" on public.recados;
create policy "Somente administradores removem recados"
on public.recados for delete
to authenticated
using (
  exists (
    select 1
    from public.administradores a
    where a.user_id = auth.uid()
  )
);

grant select, insert on public.recados to anon, authenticated;
grant delete on public.recados to authenticated;
grant select on public.administradores to authenticated;

-- Ative Realtime para a tabela recados:
-- Supabase Dashboard > Database > Publications > supabase_realtime
-- Marque a tabela public.recados (se ela ainda não estiver habilitada).
