## CleverTournament Flutter Web Architecture

### Targets and Constraints
- Primary platform: Web (Chrome first), keeping Flutter support for other platforms viable.
- UI foundation: Material 3 with expressive theming via ThemeData(colorScheme: ..., useMaterial3: true).
- State management: Riverpod (use lutter_riverpod + code-gen where helpful).
- Backend: Supabase (auth, database, realtime) using supabase_flutter.
- No third-party services beyond Supabase at v1.

### Project Structure
`
lib/
  main.dart                  # entrypoint w/ Env bootstrap + ProviderScope
  src/
    app.dart                 # Router + top-level layout shell
    core/
      config/                # env + app constants
      theme/                 # expressive color schemes + text styles
      supabase/              # client init + typed helpers
      routing/               # route definitions + guards
      utils/                 # cross-cutting helpers
    features/
      auth/                  # login/register/forgot, session providers
      onboarding/            # wizard for new organizers
      tournaments/
        data/                # repos calling Supabase
        models/              # freezed/json_serializable models
        controllers/         # riverpod notifiers
        presentation/        # pages/widgets composed per tab
      announcements/
      registrations/
      join_team/
      settings/
    widgets/                 # shared UI pieces (app bars, cards, etc)
`

### Packages
- lutter_riverpod: core state management.
- iverpod_annotation + uild_runner: code generation for providers.
- reezed, json_serializable, sealed_unions: data classes + API typing.
- supabase_flutter: auth, PostgREST, realtime.
- go_router (or Beamer alternative) for declarative routing; Riverpod integration.
- intl: formatting dates/times.
- lutter_hooks (optional) if aligned with expressive UI interactions.

### Environment & Secrets
- Use EnvConfig (lib/src/core/config/env.dart) reading from const String.fromEnvironment for SUPABASE_URL, SUPABASE_ANON_KEY.
- Local development: .vscode/launch.json or docs instruct lutter run -d chrome --dart-define=....
- Add env.sample for reference.

### Supabase Integration
- SupabaseService (singleton) responsible for client init, typed PostgREST queries, realtime subscriptions.
- Repository layer per feature for separation; avoid direct Supabase calls in widgets.
- Use row-level security friendly queries respecting policies described in .codex/FEATURES_INDEX.md.
- Async providers expose AsyncValue streams for UI.

### Routing
- Root MaterialApp.router configured with go_router.
- Shell route for auth (Guard using StreamProvider for session states).
- Named routes for: /login, /register, /tournaments, /tournaments/:id, /tournaments/:id/schedule, /join, etc.
- Query parameter parsing for /join?code=ABC123 inside GoRoute redirect.

### Theming
- Define base ColorScheme derived from palette in md/color_palette.md (if provided); fallback to Supabase brand accent for call-to-action.
- Provide expressiveness via TextTheme customization, FilledButton, SegmentedButton, NavigationRail styling.
- Include high-contrast tokens for accessibility per web targets.

### Feature Slice Responsibilities
1. **Auth**: email/password; hook session changes into Riverpod; handle password reset via Supabase.
2. **Tournaments**: CRUD, list view, creation dialog, detail shell with tabs (Pools, Schedule, Standings, Announcements, Settings).
3. **Pools/Teams**: drag-and-drop seeding (web ReorderableListView), join code display.
4. **Schedule**: generator service (pure Dart) + persistence via Supabase functions.
5. **Standings**: derived provider computing stats from games stream.
6. **Announcements**: realtime feed using Supabase Realtime.
7. **Registrations**: public form + organizer admin list.
8. **Join Team**: public route; call join_team RPC.

### Testing Strategy
- Unit tests for services, repositories, schedule generator.
- Widget tests for primary flows (login, 	ournaments list, join team).
- Use supabase_flutter offline mocking via dio interceptors or mocktail wrappers.
- Golden tests for key screens once UI stabilizes.

### Deliverables Roadmap
1. Bootstrap Flutter project with dependencies, theming scaffold, ProviderScope.
2. Implement Supabase client init and env plumbing.
3. Auth flows (login/register) + protected routing shell.
4. Tournaments list + create dialog with Riverpod repositories.
5. Iteratively add detail tabs (pools, schedule, etc.).
6. Public flows (join, registrations) and realtime enhancements.

### Outstanding Inputs
- Confirm Supabase project URL (assumed https://htuibmikqrsouqjrpotl.supabase.co).
- Confirm color palette / brand tokens (referenced in md/color_palette.md).
- Any initial data or migrations to sync with Supabase instance.
- Preferred routing package (go_router assumed).
- Accessibility/performance targets for web (Lighthouse budgets?).
