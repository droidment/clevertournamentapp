# Next Implementation Steps

1. Set up authentication feature slice:
   - Create `lib/src/features/auth` structure (data/models/controllers/presentation).
   - Implement Supabase email/password sign-in/up flows and session stream provider.
   - Guard routes using auth-aware redirects in `app_router.dart`.

2. Build tournaments list feature:
   - Scaffold models (`tournament_model.dart`) with Freezed + JSON.
   - Implement repository accessing `public.tournaments` and RLS-compliant queries.
   - Create list page with Riverpod `AsyncValue` handling and creation dialog stub.

3. Establish build tooling:
   - Add `build_runner` watch script (`scripts/build_runner_watch.ps1`).
   - Configure `analysis_options.yaml` to extend `flutter_lints` and add project-specific rules (e.g., prefer const constructors).

4. Supabase data layer foundations:
   - Add typed clients for tournaments/pools/teams with shared query helpers.
   - Integrate realtime channels for games and announcements (scaffold providers).

5. UX polish groundwork:
   - Implement adaptive layout shell (navigation rail vs. bottom navigation) using responsive breakpoints.
   - Add theme documentation referencing `md/color_palette.md` roles.
