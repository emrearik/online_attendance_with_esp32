import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';
import 'package:online_yoklama/view/student/cubit/student_cubit.dart';
import 'package:online_yoklama/view/student/services/firestore_student_services.dart';
import 'package:online_yoklama/view/student/view/home/create_qr_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const HomeScreen());
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool alertDialogClosed = false;
  String? _sessionCode;
  TextEditingController? _sessionCodeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _sessionCodeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? showAlertDialog = true;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Online Yoklama Sistemi"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
                Navigator.of(context).popAndPushNamed(SplashScreen.routeName);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: BlocConsumer<StudentCubit, StudentState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == StudentStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const PagePadding.all(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logorgb.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Hoşgeldiniz,"),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Giriş Bilgileriniz",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text("Ad Soyad: ${state.student.fullName}"),
                            const SizedBox(height: 5),
                            Text("E-Posta Adresi: ${state.student.email}"),
                            const SizedBox(height: 5),
                            Text("Okul Numarası: ${state.student.schoolNumber}")
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Oturum Kodu"),
                          ),
                          controller: _sessionCodeController,
                          onChanged: (value) {
                            setState(() {
                              _sessionCode = value;
                            });
                          },
                          validator: (value) => value!.isEmpty
                              ? 'Lütfen bir değer giriniz'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _submitButton(context, state, _sessionCode);
                          },
                          child: const Text(
                            "Karekod Oluştur",
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  _submitButton(
      BuildContext context, StudentState state, String? sessionID) async {
    final FirestoreStudentServices _firestoreStudentServices =
        locator<FirestoreStudentServices>();
    if (_formKey.currentState!.validate()) {
      String? findedSessionID = await context
          .read<StudentCubit>()
          .findSessionID(sessionID: sessionID);

      if (findedSessionID != null) {
        SessionModel findedSession =
            await _firestoreStudentServices.findSession(sessionID: sessionID);

        UserModel student = UserModel(
            userID: state.student.userID,
            email: state.student.email,
            fullName: state.student.fullName,
            permission: 0,
            schoolNumber: state.student.schoolNumber);

        Navigator.of(context).pushNamed(
          CreateQRScreen.routeName,
          arguments: CreateQRScreenArgs(
            context: context,
            student: student,
            session: findedSession,
            sessionDocumentID: findedSessionID,
          ),
        );
      } else {
        ErrorDialog.showErrorDialog(context, state);
      }
    }
  }
}
