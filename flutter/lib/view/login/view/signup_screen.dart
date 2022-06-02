import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/home/cubit/adminhome_cubit.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/login/cubit/login_cubit.dart';
import 'package:online_yoklama/view/student/cubit/student_cubit.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const String routeName = "/signup_screen";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SignupScreen(),
    );
  }

  SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kayıt Ekranı"),
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              return ErrorDialog.showErrorDialog(context, state);
            }

            if (state.status == LoginStatus.loaded) {
              Navigator.of(context).pop();
              context.read<AuthCubit>().attemptAutoLogin();
              context.read<StudentCubit>().getStudentInformation();
              context.read<AdminHomeCubit>().getAdminInformation();
            }
          },
          builder: (context, state) {
            if (state.status == LoginStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const PagePadding.all(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Okul E-posta Adresi"),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: context.read<LoginCubit>().emailChanged,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("İsim Soyisim"),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: context.read<LoginCubit>().fullNameChanged,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Okul Numarası"),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: context.read<LoginCubit>().schoolNumberChanged,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Parola"),
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: context.read<LoginCubit>().passwordChanged,
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () => _submitButton(context),
                      child: const Text("Kayıt Ol"),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  void _submitButton(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().createUserWithEmailandPassword();
    }
  }
}
