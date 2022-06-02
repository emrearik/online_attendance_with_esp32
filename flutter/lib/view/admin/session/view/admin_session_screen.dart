import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_yoklama/core/components/alert_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/session/cubit/session_cubit.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/view/add_session_screen.dart';
import 'package:online_yoklama/view/admin/attendance/view/attendance_details_screen.dart';
import 'package:online_yoklama/view/admin/session/view/update_session_screen.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';

class AdminSessionScreen extends StatelessWidget {
  static const String routeName = "/admin_session_screen";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: AdminSessionScreen.routeName),
        builder: (context) => const AdminSessionScreen());
  }

  const AdminSessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oturum Listesi"),
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
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == SessionStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const PagePadding.all(),
            child: StreamBuilder<List<SessionModel>>(
              stream: context.read<SessionCubit>().sessionList,
              builder: (context, state) {
                if ((state.data?.length ?? 0) > 0) {
                  return Column(
                    children: [
                      Text(
                          "Sistemde kayıtlı ${state.data?.length} oturum bulunuyor."),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AdminAddSessionScreen.routeName),
                          child: const Text("Oturum Ekle")),
                      SizedBox(
                          height: 440,
                          child: ListView.builder(
                            itemCount: state.data?.length,
                            itemBuilder: (context, index) {
                              return _buildSessionCard(
                                  context, state.data?[index]);
                            },
                          ))
                    ],
                  );
                } else {
                  return Center(
                    child: Column(children: [
                      const Text("Sistemde kayıtlı oturumunuz bulunmuyor."),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AdminAddSessionScreen.routeName),
                          child: const Text("Oturum Ekle")),
                    ]),
                  );
                }
              },
            ),
          );
        },
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _deleteSessionButton(context, session),
                  child: Row(
                    children: const [
                      Icon(Icons.delete),
                      Text(
                        "Sil",
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                      AdminUpdateSessionScreen.routeName,
                      arguments: UpdateSessionScreenArgs(
                          context: context, session: session!)),
                  child: Row(
                    children: const [
                      Icon(Icons.edit),
                      Text(
                        "Düzenle",
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                      AttendanceDetailsScreen.routeName,
                      arguments: AttendanceDetailsScreenArgs(
                          context: context, session: session!)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search),
                      Text(
                        "Detay",
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _deleteSessionButton(BuildContext context, SessionModel? session) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          alertDialogTitle: "Oturum Silme",
          alertDialogContent: session!.sessionID +
              " numaralı oturumu gerçekten silmek istiyor musunuz ? Bu işlem ayrıca tüm yoklama listesini de silecektir.",
          continueText: "Evet",
          cancelText: "Hayır",
          continueAction: () async {
            context.read<SessionCubit>().deleteSession(session).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Oturum başarıyla silindi."),
                backgroundColor: Colors.red,
              ));

              Navigator.of(context).pop();
            });
          },
          cancelAction: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
