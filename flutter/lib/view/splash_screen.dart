import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/view/admin/nav/admin_nav_screen.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/login/view/login_screen.dart';
import 'package:online_yoklama/view/student/nav/nav/nav_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "/splash";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SplashScreen());
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamed(NavScreen.routeName);
        }
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        }
        if (state.status == AuthStatus.adminAuthenticated) {
          Navigator.of(context).pushNamed(AdminNavScreen.routeName);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
