import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/home/cubit/adminhome_cubit.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/login/cubit/login_cubit.dart';
import 'package:online_yoklama/view/login/view/signup_screen.dart';
import 'package:online_yoklama/view/student/cubit/student_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login_screen";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => LoginScreen(),
    );
  }

  final _formKey = GlobalKey<FormState>();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Online Yoklama Sistemi"),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.loaded) {
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
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Okul E-Posta Adresi"),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: context.read<LoginCubit>().emailChanged,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'E-Posta alanı boş bırakılamaz';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Parola"),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: context.read<LoginCubit>().passwordChanged,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Parola alanı boş bırakılamaz';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: () => _submitButton(context, state),
                  child: const Text("Giriş Yap"),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
                MaterialButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(SignupScreen.routeName),
                  child: const Text("Hesabınız yok mu ? Kayıt Olun"),
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  void _submitButton(BuildContext context, LoginState state) async {
    if (_formKey.currentState!.validate()) {
      bool response =
          await context.read<LoginCubit>().loginWithEmailAndPassword();
      if (response == false) {
        ErrorDialog.showErrorDialog(context, state);
      }
    }
  }
}
