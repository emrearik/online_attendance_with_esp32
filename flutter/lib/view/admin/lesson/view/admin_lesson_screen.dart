import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:online_yoklama/core/components/alert_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/lesson/cubit/lesson_cubit.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/lesson/view/admin_add_lesson_screen.dart';
import 'package:online_yoklama/view/admin/lesson/view/admin_update_lesson_screen.dart';
import 'package:online_yoklama/view/auth/cubit/auth_cubit.dart';
import 'package:online_yoklama/view/splash_screen.dart';

class AdminLessonScreen extends StatelessWidget {
  static const String routeName = "/admin_lessonscreen";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const AdminLessonScreen());
  }

  const AdminLessonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Ders Listesi"),
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
        body: BlocConsumer<LessonCubit, LessonState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == LessonStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const PagePadding.all(),
                child: Column(
                  children: [
                    const Text(
                      "2021-2022 Eğitim Öğretim döneminindeki aktif olarak görev aldığınız ders listesi görüntüleniyor.",
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AdminAddLessonScreen.routeName),
                      child: const Text("Ders Ekle"),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child: StreamBuilder<List<LessonModel>>(
                        stream: context.read<LessonCubit>().getLessonList,
                        builder: (context, state) {
                          return ListView.builder(
                              itemCount: state.data?.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: ValueKey(index),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Sil',
                                          onPressed: (context) =>
                                              _deleteLessonButton(
                                                  context, state.data![index])),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Düzenle',
                                        onPressed: (context) =>
                                            Navigator.of(context).pushNamed(
                                                AdminUpdateLessonScreen
                                                    .routeName,
                                                arguments:
                                                    UpdateLessonScreenArgs(
                                                        lesson:
                                                            state.data![index],
                                                        context: context)),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                      child: ListTile(
                                    leading: const Icon(Icons.book),
                                    title: Text(
                                        state.data?[index].lessonName ?? ""),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(state.data?[index].lessonCode ??
                                            ""),
                                        Text(state.data?[index].user.fullName ??
                                            ""),
                                      ],
                                    ),
                                  )),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void _deleteLessonButton(BuildContext context, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogWidget(
          alertDialogTitle: "Ders Silme",
          alertDialogContent: lesson.lessonName +
              " dersini gerçekten silmek istiyor musunuz ? Bu işlem ayrıca dersteki tüm oturumları da silecektir.",
          continueText: "Evet",
          cancelText: "Hayır",
          continueAction: () async {
            context.read<LessonCubit>().deleteLesson(lesson).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Ders başarıyla silindi."),
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
