import 'package:flutter/material.dart';
import 'package:online_yoklama/core/constants/enums/bottom_nav_item.dart';
import 'package:online_yoklama/core/extension/init/navigation/custom_router.dart';
import 'package:online_yoklama/view/student/view/attendance/student_attendance_list.dart';
import 'package:online_yoklama/view/student/view/home/home_screen.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
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

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.homepage:
        return const HomeScreen();
      case BottomNavItem.details:
        return const StudentAttendanceList();

      default:
        return const Scaffold();
    }
  }
}
