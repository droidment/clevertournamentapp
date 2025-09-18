@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ------------------------------------------------------------
REM  Update the three values below with your Supabase project info
REM  before running this script.
REM ------------------------------------------------------------
set "SUPABASE_URL=https://htuibmikqrsouqjrpotl.supabase.co"
set "SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0dWlibWlrcXJzb3VxanJwb3RsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjA3MDcsImV4cCI6MjA3MzY5NjcwN30.lICkLobpH0mx8NgJDc8BptLg7t-CP5u2gnvGXGXnR2k"
set "SUPABASE_REDIRECT_URL=http://localhost:3000/"

if "%SUPABASE_ANON_KEY%"=="PASTE_YOUR_SUPABASE_ANON_KEY_HERE" (
  echo [!] Update SUPABASE_ANON_KEY in scripts\run_web_local.bat before running.
  exit /b 1
)

REM Ensure Flutter is on PATH before calling this script.
where flutter >NUL 2>&1
if errorlevel 1 (
  echo [!] Flutter SDK not found in PATH. Install Flutter or update PATH.
  exit /b 1
)

echo Running Flutter web app on http://localhost:3000/ ...
flutter run -d chrome ^
  --web-hostname localhost ^
  --web-port 3000 ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% ^
  --dart-define=SUPABASE_REDIRECT_URL=%SUPABASE_REDIRECT_URL%

endlocal