import 'package:clevertournamentapp/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:clevertournamentapp/src/features/schedule/presentation/schedule_page.dart';
import 'package:clevertournamentapp/src/features/standings/presentation/standings_page.dart';
import 'package:clevertournamentapp/src/features/tournaments/presentation/tournaments_page.dart';
import 'package:clevertournamentapp/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum HomeTab { dashboard, tournaments, schedule, standings }

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({required this.initialTab, super.key});
  final HomeTab initialTab;
  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  late HomeTab _currentTab;
  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const TournamentsPage(),
    const SchedulePage(),
    const StandingsPage(),
  ];
  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  void didUpdateWidget(HomeShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentTab = widget.initialTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useRail = constraints.maxWidth >= 960;
        final Widget stack = IndexedStack(
          index: _currentTab.index,
          children: _pages,
        );
        if (useRail) {
          final bool isExtended = constraints.maxWidth >= 1200;
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _currentTab.index,
                  onDestinationSelected:
                      (int index) => _onTabSelected(HomeTab.values[index]),
                  extended: isExtended,
                  // When extended, labels are always shown; labelType must be none
                  // to satisfy Flutter's NavigationRail assertion.
                  labelType: isExtended
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.selected,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events),
                      label: Text('Tournaments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today),
                      label: Text('Schedule'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.leaderboard_outlined),
                      selectedIcon: Icon(Icons.leaderboard),
                      label: Text('Standings'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: stack),
              ],
            ),
          );
        }
        return Scaffold(
          body: stack,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentTab.index,
            onDestinationSelected:
                (int index) => _onTabSelected(HomeTab.values[index]),
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: 'Tournaments',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'Schedule',
              ),
              NavigationDestination(
                icon: Icon(Icons.leaderboard_outlined),
                selectedIcon: Icon(Icons.leaderboard),
                label: 'Standings',
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTabSelected(HomeTab tab) {
    if (_currentTab == tab) {
      return;
    }
    setState(() => _currentTab = tab);
    switch (tab) {
      case HomeTab.dashboard:
        context.goNamed(AppRoute.dashboard.name);
        break;
      case HomeTab.tournaments:
        context.goNamed(AppRoute.tournaments.name);
        break;
      case HomeTab.schedule:
        context.goNamed(AppRoute.schedule.name);
        break;
      case HomeTab.standings:
        context.goNamed(AppRoute.standings.name);
        break;
    }
  }
}
