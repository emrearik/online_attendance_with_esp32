import 'package:flutter/material.dart';

import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRScreenArgs {
  final BuildContext context;
  final UserModel student;
  final SessionModel session;
  final String sessionDocumentID;
  CreateQRScreenArgs(
      {required this.context,
      required this.student,
      required this.session,
      required this.sessionDocumentID});
}

class CreateQRScreen extends StatelessWidget {
  static const String routeName = "/create_qr_screen";

  static Route route({required CreateQRScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CreateQRScreen(
          student: args.student,
          session: args.session,
          sessionDocumentID: args.sessionDocumentID),
    );
  }

  final UserModel student;
  final SessionModel session;
  final String sessionDocumentID;

  const CreateQRScreen(
      {Key? key,
      required this.student,
      required this.session,
      required this.sessionDocumentID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Sayfası"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              informationStudent(context, student),
              QrImage(
                data: "${student.userID}_${session.sessionID}",
                size: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget informationStudent(BuildContext context, UserModel student) {
    List<Map<String, String>> informationList = [
      {"title": "Öğrenci Adı:", "text": student.fullName},
      {"title": "Okul Numarası:", "text": student.schoolNumber},
      {"title": "Oturum Kodu:", "text": session.sessionID},
      {
        "title": "Ders Adı ve Ders Kodu:",
        "text":
            "${session.selectedLesson.lessonName} - ${session.selectedLesson.lessonCode}"
      },
      {
        "title": "Akademisyen Adı:",
        "text": session.selectedLesson.user.fullName
      },
      {
        "title": "Oturum Tarihi ve Saati:",
        "text": "${session.sessionDate} - ${session.selectedTime}"
      },
      {"title": "QR Data:", "text": "${student.userID}_${session.sessionID}"}
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      child: ListView.builder(
        itemCount: informationList.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}
