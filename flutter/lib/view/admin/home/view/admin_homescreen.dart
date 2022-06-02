import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/home/cubit/adminhome_cubit.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  static const String routeName = "/admin_homescreen";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const AdminHomeScreen());
  }

  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Akademisyen Paneli"),
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
        body: BlocConsumer<AdminHomeCubit, AdminHomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == AdminHomeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == AdminHomeStatus.loaded) {
              return Padding(
                padding: const PagePadding.all(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Hoşgeldiniz, Sayın ${state.user.fullName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<List<LessonModel>>(
                      stream: context.read<AdminHomeCubit>().getLessonList,
                      builder: (context, state) {
                        if ((state.data?.length ?? 0) > 0) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  "Sistemde kayıtlı ${state.data?.length} dersiniz bulunuyor."),
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                  "Sistemde kayıtlı dersiniz bulunmuyor. Ders ekleme sayfasından ders ekleyebilirsiniz."),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Oluşturulan Son Oturum",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<List<SessionModel>>(
                      stream: context.read<AdminHomeCubit>().lastSession,
                      builder: (context, state) {
                        if ((state.data?.length ?? 0) > 0) {
                          return _buildSessionCard(context, state.data?.last);
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                  "Sistemde kayıtlı oturum bulunmuyor. Lütfen ders ekledikten sonra oturum ekleyiniz."),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }

  Widget _buildSessionCard(BuildContext context, SessionModel? session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ders Kodu",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(session?.selectedLesson.lessonCode ?? ""),
                    const SizedBox(height: 5),
                    const Text(
                      "Ders Adı",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(session?.selectedLesson.lessonName ?? ""),
                    const SizedBox(height: 5),
                    const Text(
                      "Akademisyen Adı",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(session?.selectedLesson.user.fullName ?? ""),
                    const SizedBox(height: 5),
                    const Text(
                      "Oluşturulma Tarihi",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(session?.createdDate != null
                        ? DateFormat('dd/MM/yyyy - HH:mm:ss')
                            .format(session!.createdDate)
                        : "")
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              session?.sessionDate ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(session?.selectedTime ?? "",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Oturum ID",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(session?.sessionID ?? "",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
