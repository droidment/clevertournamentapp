# CleverTournament Feature Catalog

## Application Shell & Infrastructure
- MaterialApp configured in `lib/src/app.dart` with light/dark themes, Supabase session-aware initial route, and deep link handler for `#/join?code=...`.
- Global Supabase client bootstrapped in `lib/src/core/supabase/supabase_service.dart` with optional web override via `/env.json`.
- Custom theming in `lib/src/core/theme/app_theme.dart` providing color scheme, typography, and component styling used across pages.

## Authentication
- Email/password sign-in (`lib/src/features/auth/login_page.dart`) with validation, password visibility toggle, Google OAuth kickoff, and auth state listener to auto-route to `/home` when a session appears.
- Account creation flow (`lib/src/features/auth/register_page.dart`) capturing name/email/password, supporting Google OAuth sign-up, and redirecting to `/home` on success.
- Sign-out action in the home shell's app bar (`lib/src/features/home/home_shell.dart`) that clears the Supabase session and returns users to `/login`.

## Home Experience
- Bottom navigation shell (`lib/src/features/home/home_shell.dart`) wrapping four areas: Home dashboard, Tournaments list, Schedule placeholder, and Standings placeholder.
- Home dashboard quick actions (create, browse, register) plus 'Your tournaments' summary cards populated from Supabase for the signed-in organizer.
- Profile shortcut that opens the profile editor (`lib/src/features/profile/profile_page.dart`) for updating the user's display name via Supabase auth metadata.

## Tournament Lifecycle
- Tournaments browse/create page (`lib/src/features/tournaments/tournaments_page.dart`) showing all tournaments, sign-in prompt for guests, FAB-backed creation flow, and optimistic list updates after inserts.
- Tournament creation form (`lib/src/features/tournaments/create_tournament_page.dart`) collecting name, sport, location, and start/end dates before returning a `Tournament` object to persist.
- Tournament detail view (`lib/src/features/tournaments/tournament_detail_page.dart`) with Overview, Pools, Schedule, and Standings tabs summarizing and managing a single event.
- Overview tab actions to tweak settings, launch team registration, open rosters, surface join-code entry, and, for owners, review pending registrations and post announcements.

## Team & Player Management
- Pools tab tooling for adding/removing pools, onboarding teams (existing or new), seeding via drag-and-drop, moving teams between pools, and generating round-robin schedules.
- Team registration intake form (`lib/src/features/tournaments/team_registration_page.dart`) for authenticated users to request entry with optional captain contact details and notes.
- Registration approvals dashboard (`lib/src/features/tournaments/approvals_page.dart`) that lets organizers approve (auto-creates a team and join code) or reject submissions and revoke prior approvals.
- Team roster management (`lib/src/features/tournaments/team_roster_page.dart`) with CRUD for players, bulk import helper, join-code copy/share/regenerate actions, and roster navigation from multiple entry points.
- Public join-team flow (`lib/src/features/tournaments/join_team_page.dart`) enabling players to enter a join code, personal details, and optional jersey number/email.

## Competition Management
- Round-robin schedule generator returning `GameModel` rows for each pool and persisting them to Supabase (`_roundRobin` helper plus repository insert calls).
- Schedule tab controls for per-pool viewing, score entry dialogs, and court/time editing dialogs backed by `TournamentRepo.updateScore` and `updateGame`.
- Standings tab that streams games, aggregates wins/losses/points for teams in each pool, and renders rank rows with calculated stats.

## Communication & Settings
- Announcements panel on the Overview tab for organizers to broadcast messages (with future targeting) and attendees to read the history (`TournamentRepo.addAnnouncement` / `fetchAnnouncements`).
- Tournament settings screen (`lib/src/features/tournaments/tournament_settings_page.dart`) for choosing format, ordering tie-breakers, and maintaining the courts list used by schedule editing.
- Snackbar-based feedback across flows for success, validation errors, and authorization reminders.

## Additional Utilities
- Profile editing page (`lib/src/features/profile/profile_page.dart`) updating Supabase auth metadata and providing feedback on save.
- Placeholder schedule and standings lists in `home_shell.dart` to signal future build-out beyond the dashboard.
- Scripts and docs under `.codex/` and `scripts/` supporting Supabase SQL tooling and deployment (see reference docs).
