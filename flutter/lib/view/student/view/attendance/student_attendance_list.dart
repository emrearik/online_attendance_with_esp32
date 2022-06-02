import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';
import 'package:online_yoklama/view/student/cubit/student_cubit.dart';

@immutable
class StudentAttendanceList extends StatelessWidget {
  static const String routeName = "/student_attendance_list";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const StudentAttendanceList(),
    );
  }

  const StudentAttendanceList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yoklama Listesi"),
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
      body: Padding(
          padding: const PagePadding.all(),
          child: BlocConsumer<StudentCubit, StudentState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == StudentStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: informationStudent(context, state.student.email,
                          state.student.fullName, state.student.schoolNumber)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 500,
                    height: MediaQuery.of(context).size.height / 1.71,
                    child: StreamBuilder<List<AttendanceModel>>(
                      stream: context
                          .read<StudentCubit>()
                          .getStudentAttendanceList(),
                      builder: (context, state) {
                        if ((state.data?.length ?? 0) > 0) {
                          return ListView.builder(
                            itemCount: state.data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: sessionInformation(
                                      context,
                                      state.data?[index].session,
                                      state.data?[index].attendanceTime));
                            },
                          );
                        } else {
                          return const Text(
                              "Herhangi bir oturuma kayıtlı değilsiniz.");
                        }
                      },
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  Widget informationStudent(BuildContext context, String? email,
      String? fullName, String? schoolNumber) {
    List<Map<String, String>> informationList = [
      {"title": "Öğrenci Adı Soyadı:", "text": fullName ?? ""},
      {"title": "Öğrenci Numarası:", "text": schoolNumber ?? ""},
      {"title": "Öğrenci E-Posta:", "text": email ?? ""},
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 7.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: informationList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    informationList[i]["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(informationList[i]["text"]!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sessionInformation(
      BuildContext context, SessionModel? session, double? attendanceTime) {
    final FirestoreSessionService _firestoreSessionService =
        locator<FirestoreSessionService>();

    List<Map<String, String>> informationList = [
      {"title": "Oturum ID:", "text": session?.sessionID ?? ""},
      {"title": "Ders Kodu:", "text": session?.selectedLesson.lessonCode ?? ""},
      {"title": "Ders Adı:", "text": session?.selectedLesson.lessonName ?? ""},
      {"title": "Oturum Tarihi:", "text": session?.sessionDate ?? ""},
      {"title": "Oturum Saati:", "text": session?.selectedTime ?? ""},
      {
        "title": "Akademisyen Adı:",
        "text": session?.selectedLesson.user.fullName ?? ""
      },
      {
        "title": "Yoklama Tarihi:",
        "text": _firestoreSessionService.timestampToDate(attendanceTime)
      }
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: informationList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    informationList[i]["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(informationList[i]["text"]!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
