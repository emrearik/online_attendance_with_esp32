import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/lesson/cubit/lesson_cubit.dart';

class AdminAddLessonScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const String routeName = "/admin_add_lesson_screen";

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => AdminAddLessonScreen());
  }

  AdminAddLessonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ders Ekleme",
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
                    onChanged: context.read<LessonCubit>().changedLessonCode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen ders kodu giriniz';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Ders Adı"),
                      ),
                      onChanged: context.read<LessonCubit>().changedLessonName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen ders adı giriniz';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done),
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
      ),
    );
  }

  _submitButton(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LessonCubit>().addLesson().then((value) {
        if (value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ders Başarıyla Eklendi"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
      });
    }
  }
}
