import 'package:flutter/material.dart';
import 'package:online_yoklama/view/admin/home/view/admin_homescreen.dart';
import 'package:online_yoklama/view/admin/lesson/view/admin_add_lesson_screen.dart';
import 'package:online_yoklama/view/admin/lesson/view/admin_update_lesson_screen.dart';
import 'package:online_yoklama/view/admin/nav/admin_nav_screen.dart';
import 'package:online_yoklama/view/admin/session/view/add_session_screen.dart';
import 'package:online_yoklama/view/admin/session/view/admin_session_screen.dart';
import 'package:online_yoklama/view/admin/attendance/view/attendance_details_screen.dart';
import 'package:online_yoklama/view/admin/session/view/update_session_screen.dart';
import 'package:online_yoklama/view/login/view/login_screen.dart';
import 'package:online_yoklama/view/login/view/signup_screen.dart';
import 'package:online_yoklama/view/splash_screen.dart';
import 'package:online_yoklama/view/student/nav/nav/nav_screen.dart';
import 'package:online_yoklama/view/student/view/attendance/student_attendance_list.dart';
import 'package:online_yoklama/view/student/view/home/create_qr_screen.dart';
import 'package:online_yoklama/view/student/view/home/home_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint("Route: ${settings.name}");
    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case AdminNavScreen.routeName:
        return AdminNavScreen.route();
      case AdminHomeScreen.routeName:
        return AdminHomeScreen.route();
      case AdminSessionScreen.routeName:
        return AdminSessionScreen.route();
      case StudentAttendanceList.routeName:
        return StudentAttendanceList.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    debugPrint("NestedRoute: ${settings.name}");
    switch (settings.name) {
      case CreateQRScreen.routeName:
        return CreateQRScreen.route(
          args: settings.arguments as CreateQRScreenArgs,
        );
      case AdminAddLessonScreen.routeName:
        return AdminAddLessonScreen.route();
      case AdminAddSessionScreen.routeName:
        return AdminAddSessionScreen.route();
      case AdminUpdateLessonScreen.routeName:
        return AdminUpdateLessonScreen.route(
          args: settings.arguments as UpdateLessonScreenArgs,
        );
      case AttendanceDetailsScreen.routeName:
        return AttendanceDetailsScreen.route(
          args: settings.arguments as AttendanceDetailsScreenArgs,
        );
      case AdminUpdateSessionScreen.routeName:
        return AdminUpdateSessionScreen.route(
          args: settings.arguments as UpdateSessionScreenArgs,
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Sistemde bir hata oluştu !")),
      ),
    );
  }
}
