import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_frontend/screens/list.dart';
import 'package:todo_frontend/screens/add_new_list_entry.dart';
import 'package:todo_frontend/widgets/scaffold_with_navbar.dart';

enum RouterDestinations {
  list(url: '/'),
  add(url: '/add');

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
  initialLocation: RouterDestinations.list.url,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavbar(child: child);
      },
      routes: [
        GoRoute(
          path: RouterDestinations.list.url,
          name: "list",
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute
          (
          path: RouterDestinations.add.url,
          name: "add",
          builder: (context, state) => AddNewListEntryScreen(),
        ),
      ],
    ),
  ],
);