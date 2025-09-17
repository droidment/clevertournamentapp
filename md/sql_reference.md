# Supabase SQL Reference

This cheat sheet tracks the SQL the Flutter client relies on and handy snippets for maintaining parity with the codebase.

## Core Schema Alignment

```sql
-- Add jsonb settings to tournaments if it is missing
do $$
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'tournaments' and column_name = 'settings'
  ) then
    alter table public.tournaments add column settings jsonb default '{}'::jsonb;
  end if;
end$$;

-- Enrich teams table with fields used by the app
alter table public.teams
  add column if not exists pool_id uuid references public.pools(id) on delete set null,
  add column if not exists seed int default 0,
  add column if not exists captain_name text,
  add column if not exists captain_email text,
  add column if not exists captain_phone text,
  add column if not exists jersey_color text,
  add column if not exists join_code text,
  add column if not exists inserted_at timestamptz not null default now();
create index if not exists teams_tournament_pool_seed_idx on public.teams(tournament_id, pool_id, seed);
```

## Tables Required by the App

```sql
-- Players associated with a team roster
create table if not exists public.players (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  name text not null,
  number int,
  email text,
  inserted_at timestamptz not null default now()
);

-- Announcements broadcast for a tournament
create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.tournaments(id) on delete cascade,
  content text not null,
  target text not null default 'all',
  created_by uuid,
  inserted_at timestamptz not null default now()
);

-- Public team registration queue
create table if not exists public.team_registrations (
  id uuid primary key default gen_random_uuid(),
  tournament_id uuid not null references public.tournaments(id) on delete cascade,
  team_name text not null,
  captain_name text,
  captain_email text,
  captain_phone text,
  notes text,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_by uuid references auth.users(id),
  team_id uuid references public.teams(id) on delete set null,
  inserted_at timestamptz not null default now()
);
```

## join_team RPC Template

```sql
create or replace function public.join_team(
  p_code text,
  p_name text,
  p_number int,
  p_email text
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_team public.teams%rowtype;
  v_player_id uuid;
begin
  select * into v_team
  from public.teams
  where upper(join_code) = upper(trim(p_code))
  limit 1;

  if v_team.id is null then
    raise exception 'Invalid join code';
  end if;

  insert into public.players(team_id, name, number, email)
  values (v_team.id, trim(p_name), p_number, nullif(trim(p_email), ''))
  returning id into v_player_id;

  return v_player_id;
end;
$$;

grant execute on function public.join_team(text, text, int, text) to anon;
```

## Row Level Security Snippets

```sql
alter table public.players enable row level security;
alter table public.announcements enable row level security;
alter table public.team_registrations enable row level security;

-- Allow public read access
create policy if not exists players_read_all on public.players
  for select using (true);
create policy if not exists announcements_read_all on public.announcements
  for select using (true);
create policy if not exists registrations_read_all on public.team_registrations
  for select using (auth.uid() = created_by or
    exists (select 1 from public.tournaments t where t.id = tournament_id and t.created_by = auth.uid()));

-- Organizer write access helpers
create policy if not exists players_manage_if_owner on public.players
  for all using (
    exists(
      select 1 from public.teams tm
      join public.tournaments tr on tr.id = tm.tournament_id
      where tm.id = players.team_id and tr.created_by = auth.uid()
    )
  );
```

## Handy Verification Queries

```sql
-- List tournaments with team counts
select t.name, count(tm.id) as teams
from public.tournaments t
left join public.teams tm on tm.tournament_id = t.id
group by t.id
order by t.inserted_at desc;

-- Check pending registrations for a tournament
select team_name, status, captain_email
from public.team_registrations
where tournament_id = :tournament_id
order by inserted_at desc;

-- Inspect upcoming games with team names
select g.id, p.name as pool, ta.name as team_a, tb.name as team_b, g.start_time, g.court
from public.games g
left join public.pools p on p.id = g.pool_id
left join public.teams ta on ta.id = g.team_a
left join public.teams tb on tb.id = g.team_b
where g.tournament_id = :tournament_id
order by g.start_time nulls last;
```

## Maintenance Reminders

- Run migrations through `supabase/migrations` so environments remain reproducible.
- Revisit indexes after enabling large schedules or rosters to keep queries under a few milliseconds.
- When updating security definer functions, reapply `alter function ... owner to postgres` (or service role) if Supabase resets ownership.

