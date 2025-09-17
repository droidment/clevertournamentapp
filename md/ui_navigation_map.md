# UI Navigation Map

## Top-Level Routes
- `/login` -> `LoginPage` (email/password plus Google). Navigates to `/home` on success or to `/register` via the 'Create account' button.
- `/register` -> `RegisterPage`. On successful sign-up it replaces with `/home`; Google OAuth reuses the same listener.
- `/home` -> `HomeShell` with bottom navigation (`Home`, `Tournaments`, `Schedule`, `Standings`). App bar actions open profile or sign out (back to `/login`).
- `#/join?code=XYZ` deep link handled in `lib/src/app.dart` -> `JoinTeamPage(initialCode: XYZ)`.

## HomeShell Internals
- Home tab (`_HomeDashboard`) shows quick actions. Create pushes `CreateTournamentPage`; Browse pushes `TournamentsPage` in a full screen route.
- Bottom navigation swaps in `TournamentsPage`, schedule placeholder, and standings placeholder without extra routes.
- App bar profile icon opens `ProfilePage`; save pops back. Logout clears Supabase session and removes all routes before showing `/login`.

## Tournaments Flow
- `TournamentsPage` (both standalone and inside HomeShell) lists tournaments and exposes a FAB to push `CreateTournamentPage`.
- Selecting a tournament pushes `TournamentDetailPage` with four tabs:
  - Overview tab buttons route to `TournamentSettingsPage`, `TeamRegistrationPage`, `TeamRosterPage` (via picker), `JoinTeamPage`, and `ApprovalsPage` (owner only).
  - Pools tab hosts add/move/delete dialogs and links back into `TeamRosterPage` for roster editing.
  - Schedule tab streams games; tapping a card opens a score dialog, long-press opens a detail edit dialog.
  - Standings tab renders computed tables with no navigation hooks.

## Team & Player Management
- `TeamRegistrationPage` submits data then pops back to the detail page.
- `ApprovalsPage` lets organizers approve (creating a team) or reject registrations and stays on stack after actions.
- `TeamRosterPage` is reachable from Overview actions and Pools tab cards; dialogs inside handle add/edit/import players while the route stays active.
- `JoinTeamPage` is launched from Overview or deep link; success posts a snackbar then pops.

## Navigation Diagram
```text
LoginPage (/login)
  |-> RegisterPage (/register)
  \-> HomeShell (/home)
        |-- HomeDashboard
        |    |-> CreateTournamentPage
        |    \-> TournamentsPage
        |-- TournamentsPage (tab)
        |-- Schedule placeholder (tab)
        \-- Standings placeholder (tab)
        
TournamentsPage (any entry)
  \-> TournamentDetailPage
        |-- Overview tab
        |    |-> TournamentSettingsPage
        |    |-> TeamRegistrationPage
        |    |-> TeamRosterPage (via picker)
        |    |-> JoinTeamPage
        |    \-> ApprovalsPage (owner only)
        |-- Pools tab
        |    |-- dialogs (add/move/delete)
        |    \-> TeamRosterPage
        |-- Schedule tab (score/edit dialogs)
        \-- Standings tab (read only)

Profile icon -> ProfilePage -> pop
Join deep link (#/join?code=) -> JoinTeamPage -> pop
Logout -> clears stack -> /login
```

## Modal / Dialog Usage
- Add/edit pool, team, and player dialogs live inside their respective tabs so navigation stack does not change.
- Overview bottom sheet lists teams before routing to `TeamRosterPage`.
- Schedule tab uses dialogs for scores and game edits; no dedicated pages yet.

## Notes for Future Mapping
- Schedule and Standings tabs inside `HomeShell` are placeholders; update this map when they gain full pages.
- If you add new deep links (for example `/tournament/:id`), register them in `lib/src/app.dart` and echo the behavior here.
