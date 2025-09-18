import 'package:clevertournamentapp/src/app_shell/home_shell_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/controllers/auth_session_providers.dart';
import '../features/auth/models/app_user.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/tournaments/presentation/tournament_detail_page.dart';

enum AppRoute {
  login,
  register,
  dashboard,
  tournaments,
  schedule,
  standings,
  profile,
  tournamentDetail,
}

extension AppRoutePath on AppRoute {
  String get path => switch (this) {
    AppRoute.login => '/login',
    AppRoute.register => '/register',
    AppRoute.dashboard => '/',
    AppRoute.tournaments => '/tournaments',
    AppRoute.schedule => '/schedule',
    AppRoute.standings => '/standings',
    AppRoute.profile => '/profile',
    AppRoute.tournamentDetail => '/tournaments/:id',
  };

  String get name => switch (this) {
    AppRoute.login => 'login',
    AppRoute.register => 'register',
    AppRoute.dashboard => 'dashboard',
    AppRoute.tournaments => 'tournaments',
    AppRoute.schedule => 'schedule',
    AppRoute.standings => 'standings',
    AppRoute.profile => 'profile',
    AppRoute.tournamentDetail => 'tournamentDetail',
  };
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  final router = GoRouter(
    initialLocation: AppRoute.dashboard.path,
    refreshListenable: notifier,
    redirect: notifier.handleRedirect,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(child: RegisterPage());
        },
      ),
      GoRoute(
        path: AppRoute.dashboard.path,
        name: AppRoute.dashboard.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(
            child: HomeShellPage(initialTab: HomeTab.dashboard),
          );
        },
      ),
      GoRoute(
        path: AppRoute.tournaments.path,
        name: AppRoute.tournaments.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(
            child: HomeShellPage(initialTab: HomeTab.tournaments),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: ':id',
            name: AppRoute.tournamentDetail.name,
            builder: (BuildContext context, GoRouterState state) {
              final String id = state.pathParameters['id']!;
              return TournamentDetailPage(tournamentId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.schedule.path,
        name: AppRoute.schedule.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(
            child: HomeShellPage(initialTab: HomeTab.schedule),
          );
        },
      ),
      GoRoute(
        path: AppRoute.standings.path,
        name: AppRoute.standings.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(
            child: HomeShellPage(initialTab: HomeTab.standings),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage(child: ProfilePage());
        },
      ),
    ],
    debugLogDiagnostics: true,
  );

  ref.onDispose(() {
    router.dispose();
    notifier.dispose();
  });

  return router;
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this.ref) {
    _subscription = ref.listen<AsyncValue<AppUser?>>(authSessionProvider, (
      AsyncValue<AppUser?>? previous,
      AsyncValue<AppUser?> next,
    ) {
      final previousUser = previous?.valueOrNull;
      final nextUser = next.valueOrNull;
      if (previousUser?.id != nextUser?.id) {
        notifyListeners();
      }
    });
  }

  final Ref ref;
  late final ProviderSubscription<AsyncValue<AppUser?>> _subscription;

  String? handleRedirect(BuildContext context, GoRouterState state) {
    final authState = ref.read(authSessionProvider);
    if (authState.isLoading) {
      return null;
    }

    final user = authState.valueOrNull;
    final bool isAuthenticated = user != null;
    final String location = state.uri.path;
    final bool isOnAuthPage =
        location == AppRoute.login.path || location == AppRoute.register.path;

    if (!isAuthenticated) {
      return isOnAuthPage ? null : AppRoute.login.path;
    }

    if (isOnAuthPage) {
      return AppRoute.dashboard.path;
    }

    return null;
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
