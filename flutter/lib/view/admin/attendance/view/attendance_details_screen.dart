import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';

import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/cubit/attendance_cubit.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AttendanceDetailsScreenArgs {
  final BuildContext context;
  final SessionModel session;

  AttendanceDetailsScreenArgs({
    required this.context,
    required this.session,
  });
}

class AttendanceDetailsScreen extends StatefulWidget {
  final SessionModel? session;
  static const String routeName = "/admin_session_detail";

  static Route route({required AttendanceDetailsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => AttendanceDetailsScreen(
        session: args.session,
      ),
    );
  }

  const AttendanceDetailsScreen({Key? key, required this.session})
      : super(key: key);

  @override
  State<AttendanceDetailsScreen> createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Oturum Detayları",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const PagePadding.all(),
            child: BlocConsumer<AttendanceCubit, AttendanceState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.status == AttendanceStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StreamBuilder<List<AttendanceModel>>(
                  stream: context.read<AttendanceCubit>().getAttandanceList(
                      sessionID: widget.session?.sessionID ?? ""),
                  builder: (context, state) {
                    if ((state.data?.length ?? 0) > 0) {
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: informationSession(
                                    context,
                                    widget.session,
                                    state.data?.length.toString())),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 500,
                            child: ListView.builder(
                              itemCount: state.data?.length,
                              itemBuilder: (context, index) {
                                return informationStudent(
                                    context,
                                    state.data?[index].student,
                                    state.data?[index].attendanceTime);
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text(
                              "Bu oturumda yoklaması alınmış öğrenci bulunamadı."));
                    }
                  },
                );
              },
            )),
      ),
    );
  }

  Widget informationSession(
      BuildContext context, SessionModel? session, String? totalStudentLength) {
    List<Map<String, String>> informationList = [
      {"title": "Oturum Kodu:", "text": session?.sessionID ?? ""},
      {"title": "Ders Adı:", "text": session?.selectedLesson.lessonName ?? ""},
      {"title": "Ders Kodu:", "text": session?.selectedLesson.lessonCode ?? ""},
      {"title": "Oturum Tarihi:", "text": session?.sessionDate ?? ""},
      {"title": "Oturum Saati:", "text": session?.selectedTime ?? ""},
      {"title": "Toplam Öğrenci Sayısı:", "text": totalStudentLength ?? ""},
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.4,
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
    );
  }

  Widget informationStudent(
      BuildContext context, UserModel? student, double? attendanceTime) {
    final FirestoreSessionService _firestoreSessionService =
        locator<FirestoreSessionService>();
    List<Map<String, String>> informationList = [
      {"title": "Ad Soyad:", "text": student?.fullName ?? ""},
      {"title": "Numara:", "text": student?.schoolNumber ?? ""},
      {
        "title": "Yoklama Tarihi:",
        "text": _firestoreSessionService.timestampToDate(attendanceTime)
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: informationList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
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
            QrImage(
                size: 80,
                data: "${student?.userID}_${widget.session?.sessionID}")
          ],
        ),
      ),
    );
  }
}
