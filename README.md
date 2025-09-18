# CleverTournamentApp

Flutter + Supabase app for managing tournaments, teams, and schedules across web and mobile targets.

## Local Development

- Install Flutter (stable channel) and run `flutter pub get`.
- Provide Supabase environment values using `--dart-define` flags or override defaults in `lib/src/core/config/env.dart`.
- Launch the app with `flutter run` (mobile/desktop) or `flutter run -d chrome` for web.
- Generate Freezed/JSON outputs when models change: `flutter pub run build_runner build --delete-conflicting-outputs`.

### Google Sign-In setup

1. In Supabase Dashboard ? Authentication ? Providers, enable **Google** and add the authorized redirect URIs your platforms require (e.g. `https://clevertournament.web.app/` for web, custom scheme such as `com.clevertournament.app://login-callback` for mobile).
2. Provide `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and (for mobile) `SUPABASE_REDIRECT_URL` via `--dart-define` or update `EnvConfig` defaults.
3. If you target iOS/Android, register the same redirect URI in the respective platform files (`AndroidManifest.xml` deep link / iOS URL types).

## Testing

```
flutter test
```

Widget tests expect a mocked Supabase client; add an initialization guard before enabling CI runs.

## Deployment

### Firebase Hosting (Flutter web)

Pushing to the `main` branch automatically builds the Flutter web bundle and deploys it to Firebase Hosting via `.github/workflows/firebase-hosting.yml`.

#### Required GitHub secrets

| Secret | Purpose |
| --- | --- |
| `FIREBASE_SERVICE_ACCOUNT` | JSON for a Firebase service account with `Firebase Hosting Admin` and `Cloud Build Service Account` roles. |
| `FIREBASE_PROJECT_ID` | Firebase project ID that owns the hosting site. |

The workflow runs `flutter build web --release` and publishes the contents of `build/web`. To trigger the workflow manually, use *Run workflow* from the Actions tab.

---

For database schema, UI plans, and future roadmap, see the docs under `md/`.