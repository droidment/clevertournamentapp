# CleverTournament Database Work Log

## Supabase Client Wiring
- `lib/src/core/supabase/supabase_service.dart` boots Supabase with PKCE auth and optional `/env.json` override when running on web.
- All feature code uses `Supabase.instance.client`; keep anon key and URL supplied through `Env` constants or runtime defines.

## Data Model Summary
| Table | Key columns expected by app | Primary usage |
| --- | --- | --- |
| `public.tournaments` | `id`, `name`, `sport`, `location`, `start_date`, `end_date`, `created_by`, `settings` (jsonb), `inserted_at`, `updated_at` | Listing (`TournamentsPage`), dashboard, detail header, settings fetch/save |
| `public.pools` | `id`, `tournament_id`, `name`, `position` | Pools tab management and ordering |
| `public.teams` | `id`, `tournament_id`, `name`, `pool_id`, `seed`, `captain_name`, `captain_email`, `captain_phone`, `jersey_color`, `join_code`, `inserted_at` | Pools tab team CRUD, roster links, join codes, approvals |
| `public.players` | `id`, `team_id`, `name`, `number`, `email`, `inserted_at` | Team roster page player CRUD |
| `public.games` | `id`, `tournament_id`, `pool_id`, `court`, `start_time`, `team_a`, `team_b`, `score_a`, `score_b`, `status` | Schedule tab streaming, standings aggregation, score entry |
| `public.announcements` | `id`, `tournament_id`, `content`, `target`, `inserted_at`, `created_by` | Overview tab announcements panel |
| `public.team_registrations` | `id`, `tournament_id`, `team_name`, `captain_name`, `captain_email`, `captain_phone`, `notes`, `status`, `created_by`, `team_id`, `inserted_at` | Public registration form and organizer approvals |
| `auth.users` metadata | `full_name` stored in `user_metadata` | Profile page display name field |

## RPCs, Triggers, and Helpers
- **`public.join_team(p_code, p_name, p_number, p_email)`**: required by `TournamentRepo.joinTeam`; should validate the join code, insert a `players` row, and return the new player id. Use SECURITY DEFINER and grant execute to `anon`.
- **`set_updated_at()` trigger**: provided in `supabase/migrations/0001_init.sql`; keep it attached to mutable tables so `updated_at` stays current.
- Optionally add triggers or service-role defaults to fill `tournaments.created_by` and `teams.join_code` automatically when inserts omit them.

## Row Level Security Expectations
- RLS enabled on all business tables. Anonymous users may select for browsing; organizers (tournament `created_by`) should own write access.
- Authenticated users can submit registrations; approvals and team management require organizer privileges.
- The `join_team` RPC bypasses direct table writes so players without accounts can join by code while respecting RLS.

## Repository Touch Points (`lib/src/features/tournaments/data/tournament_repo.dart`)
- Pools: `fetchPools`, `addPool`, `removePool`, `reorderPools` (individual updates).
- Teams: `fetchTeams`, `addTeam`, `assignTeamToPool`, `updateTeam`, `deleteTeam`, `setSeeds`, `regenerateJoinCode`.
- Registrations: `submitRegistration`, `fetchRegistrations`, `approveRegistration`, `updateRegistrationStatus` (revoke supported).
- Games: `fetchGames`, `streamGames`, `insertGames`, `clearGamesForPool`, `updateGame`, `updateScore`.
- Players: `fetchPlayers`, `addPlayer`, `removePlayer` (edit flow deletes then recreates).
- Announcements: `fetchAnnouncements`, `addAnnouncement`, `streamAnnouncements`.
- Settings: `fetchSettings`, `saveSettings` storing JSON under `tournaments.settings`.

## Schema Sources in Repo
- `supabase/migrations/0001_init.sql` seeds core tables (tournaments, pools, teams, games) and baseline policies.
- Legacy design docs under `md/` (`supabase_schema.sql`, `supabase_rls_policies.sql`, `supabase_functions.sql`) outline an expanded model; reconcile with live migrations before applying.
- `.codex/FEATURES_INDEX.md` catalogs desired schema and feature connections for quick reference.

## Gaps and Follow Ups
- Existing migration is missing `players`, `announcements`, `team_registrations`, and several columns (`teams.seed`, `teams.join_code`, `tournaments.settings`, etc.); create incremental migrations to align Postgres with current models.
- Ensure `team_registrations.status` enum/default (`pending` -> `approved`/`rejected`) matches client expectations and that organizer RLS can update those rows.
- Confirm `games` column names (`team_a`, `team_b`, `score_a`, `score_b`) match the schema; update migration or mapper if different.
- Grant execute on `join_team` to `anon` and verify policies let organizers manage dependent rows without service keys.
- Add useful indexes (for example `teams(tournament_id, pool_id, seed)` and `games(tournament_id, start_time)`) as data grows.

## Operational Notes
- Scripts: `scripts/supabase_sql.ps1` and `.codex/tools/supabase-sql/` provide CLI/MCP access to the Supabase SQL API for quick migration tests.
- Keep Supabase project reference and service keys updated in `.codex/config.toml` when automating SQL runs.
- When shipping schema changes, drop new SQL into `supabase/migrations/` and record the intent in this log for future context.
- Updated teams schema to store city, state, and jersey_color instead of contact info (2025-09-18).
