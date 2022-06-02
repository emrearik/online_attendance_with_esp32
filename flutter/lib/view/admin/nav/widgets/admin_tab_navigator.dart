import 'package:flutter/material.dart';
import 'package:online_yoklama/core/constants/enums/admin_bottom_nav_item.dart';
import 'package:online_yoklama/core/extension/init/navigation/custom_router.dart';
import 'package:online_yoklama/view/admin/home/view/admin_homescreen.dart';
import 'package:online_yoklama/view/admin/lesson/view/admin_lesson_screen.dart';
import 'package:online_yoklama/view/admin/session/view/admin_session_screen.dart';

class AdminTabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final AdminBottomNavItem item;

  const AdminTabNavigator(
      {Key? key, required this.navigatorKey, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, AdminBottomNavItem item) {
    switch (item) {
      case AdminBottomNavItem.homepage:
        return const AdminHomeScreen();
      case AdminBottomNavItem.lesson:
        return const AdminLessonScreen();
      case AdminBottomNavItem.session:
        return const AdminSessionScreen();

      default:
        return const Scaffold();
    }
  }
}
