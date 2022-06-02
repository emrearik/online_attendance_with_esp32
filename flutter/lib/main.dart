import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/extension/init/navigation/custom_router.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/cubit/attendance_cubit.dart';
import 'package:online_yoklama/view/admin/home/cubit/adminhome_cubit.dart';
import 'package:online_yoklama/view/admin/lesson/cubit/lesson_cubit.dart';
import 'package:online_yoklama/view/admin/nav/cubit/admin_bottom_navbar_cubit.dart';
import 'package:online_yoklama/view/admin/session/cubit/session_cubit.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/login/cubit/login_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';
import 'package:online_yoklama/view/student/cubit/student_cubit.dart';
import 'package:online_yoklama/view/student/nav/cubit/bottom_navbar_cubit.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<AdminBottomNavBarCubit>(
          create: (context) => AdminBottomNavBarCubit(),
        ),
        BlocProvider<BottomNavBarCubit>(
          create: (context) => BottomNavBarCubit(),
        ),
        BlocProvider<AdminHomeCubit>(
          create: (context) => AdminHomeCubit(),
        ),
        BlocProvider<LessonCubit>(
          create: (context) => LessonCubit(),
        ),
        BlocProvider<SessionCubit>(
          create: (context) => SessionCubit(),
        ),
        BlocProvider<AttendanceCubit>(
          create: (context) => AttendanceCubit(),
        ),
        BlocProvider<StudentCubit>(
          create: (context) => StudentCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Online Yoklama Sistemi',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        onGenerateRoute: CustomRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
