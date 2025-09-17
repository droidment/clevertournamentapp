# CleverTournament UI Navigation Map

## Entry Flow
- `main.dart` boots `CleverTournamentApp`, which loads Supabase then launches a `MaterialApp` (`lib/src/app.dart:10`).
- Initial route resolves to `/home` when a session exists or `/login` otherwise (`lib/src/app.dart:24`).
- Deep link handler parses `/join?code=` and pushes `JoinTeamPage` with the provided code (`lib/src/app.dart:30`).

## Auth Surfaces
- `/login` → `LoginPage` (`lib/src/features/auth/login_page.dart:14`) with links to registration, Google OAuth, and automatic redirect on auth state change.
- `/register` → `RegisterPage` (`lib/src/features/auth/register_page.dart:14`) mirroring login options while capturing display name.

## Home Shell (`/home`)
- `HomeShell` wraps the signed-in experience with a `NavigationBar` and four destinations (`lib/src/features/home/home_shell.dart:33`).
  - Tab 0 – **Home**: dashboard cards and quick actions (placeholders for create/register/announce).
  - Tab 1 – **Tournaments**: list and create flow, launches detail pages.
  - Tab 2 – **Schedule**: placeholder list awaiting global schedule integration.
  - Tab 3 – **Standings**: placeholder standings summary.
- App bar actions: profile opens `ProfilePage`; sign-out clears session and routes back to `/login` (`lib/src/features/home/home_shell.dart:40`).

## Tournament List → Detail
- `TournamentsPage` fetches events and opens `TournamentDetailPage` on tap (`lib/src/features/tournaments/tournaments_page.dart:148`).
- Floating action button launches `CreateTournamentPage`; successful save returns to list and persists to Supabase.

## Tournament Detail Tabs (`lib/src/features/tournaments/tournament_detail_page.dart:70`)
- **Overview**: summary card plus action buttons
  - Settings (`TournamentSettingsPage`) for configuration JSON.
  - Playoffs viewer (`PlayoffsPage`) and modal generator sheet.
  - Team registration form (`TeamRegistrationPage`), rosters modal → `TeamRosterPage` push.
  - Join-with-code button (pushes `JoinTeamPage`) and approvals list (`ApprovalsPage`) for owners.
  - Announcements composer with realtime feed.
- **Pools**: lists pool cards, each allowing team management, seeding mode toggle, team dialogs, and schedule generation.
- **Schedule**: realtime games list with tap-to-edit scores, long-press for court/time dialog.
- **Standings**: realtime standings grouped by pool with tie-breaker aware ordering.

## Rosters & Registration Paths
- `TeamRosterPage` (from Overview or Pools) supports add/edit/remove players, join-code utilities, and QR modal.
- `TeamRegistrationPage` accessible from Overview for public team submissions; success pops back to detail.
- `ApprovalsPage` accessible to tournament owner from Overview for reviewing registrations.

## Public Join Workflow
- Direct navigation to `/join` (deep link) or buttons within the app launch `JoinTeamPage` for code entry and roster join via RPC (`lib/src/features/tournaments/join_team_page.dart:17`).

## Profile & Sign-out
- Profile icon (home shell) pushes `ProfilePage` for updating display name (`lib/src/features/profile/profile_page.dart:14`).
- Sign-out clears session and removes all routes before redirecting to `/login`.
