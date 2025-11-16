import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_frontend/screens/home.dart';
import 'package:todo_frontend/widgets/scaffold_with_navbar.dart';

enum RouterDestinations {
  home(url: '/'),
  login(url: '/login');

  final String url;
  const RouterDestinations({required this.url});
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouterDestinations.login.url,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavbar(child: child);
      },
      routes: [
        GoRoute(
          path: RouterDestinations.home.url,
          name: "Die Hugos",
          builder: (context, state) => HomeScreen(),
        ),

      ],
    ),
  ],
);