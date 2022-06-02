import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/lesson/cubit/lesson_cubit.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';

class UpdateLessonScreenArgs {
  final LessonModel lesson;
  final BuildContext context;
  UpdateLessonScreenArgs({required this.lesson, required this.context});
}

class AdminUpdateLessonScreen extends StatefulWidget {
  final LessonModel lesson;
  static const String routeName = "/update_lesson_screen";

  static Route route({required UpdateLessonScreenArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => AdminUpdateLessonScreen(
              lesson: args.lesson,
            ));
  }

  const AdminUpdateLessonScreen({Key? key, required this.lesson})
      : super(key: key);

  @override
  State<AdminUpdateLessonScreen> createState() =>
      _AdminUpdateLessonScreenState();
}

class _AdminUpdateLessonScreenState extends State<AdminUpdateLessonScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _lessonCodeController;
  TextEditingController? _lessonNameController;

  String? _lessonName;
  String? _lessonCode;
  @override
  void dispose() {
    _lessonCodeController?.dispose();
    _lessonNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ders Düzenleme",
          ),
        ),
        body: BlocConsumer<LessonCubit, LessonState>(
          listener: (context, state) {
            if (state.status == LessonStatus.error) {
              return ErrorDialog.showErrorDialog(context, state);
            }
          },
          builder: (context, state) {
            if (state.status == LessonStatus.loading) {
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
                        label: Text("Ders Kodu"),
                      ),
                      controller: _lessonCodeController,
                      initialValue: widget.lesson.lessonCode,
                      onChanged: (value) {
                        setState(() {
                          _lessonCode = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen ders kodu giriniz';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Ders Adı"),
                      ),
                      controller: _lessonNameController,
                      initialValue: widget.lesson.lessonName,
                      onChanged: (value) {
                        setState(() {
                          _lessonName = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen ders adı giriniz';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitButton(context),
                      child: const Text("Kaydet"),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  _submitButton(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_lessonCode != null || _lessonName != null) {
        context
            .read<LessonCubit>()
            .updateLesson(
              oldLesson: widget.lesson,
              lessonCode: _lessonCode ?? widget.lesson.lessonCode,
              lessonName: _lessonName ?? widget.lesson.lessonName,
            )
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Ders başarıyla güncellendi."),
              backgroundColor: Colors.green,
            ));

            Navigator.of(context).pop();
          }
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
