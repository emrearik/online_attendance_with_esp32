import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/cubit/session_cubit.dart';

class AdminAddSessionScreen extends StatefulWidget {
  static const String routeName = "/admin_add_session";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SessionCubit>(
        create: (context) => SessionCubit(),
        child: const AdminAddSessionScreen(),
      ),
    );
  }

  const AdminAddSessionScreen({Key? key}) : super(key: key);

  @override
  State<AdminAddSessionScreen> createState() => _AdminAddSessionScreenState();
}

class _AdminAddSessionScreenState extends State<AdminAddSessionScreen> {
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 13, minute: 00);
  LessonModel? _selectedLesson;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oturum Ekle"),
      ),
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state.status == SessionStatus.error) {
            return ErrorDialog.showErrorDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state.status == SessionStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const PagePadding.all(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showDatePicker(
                            context: context,
                            initialDate: _selectedDate == null
                                ? DateTime.now()
                                : _selectedDate!,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2023))
                        .then((value) {
                      setState(() {
                        _selectedDate = value;
                      });
                    }),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.date_range,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tarih Seçimi"),
                                const SizedBox(height: 10),
                                Text(
                                  _selectedDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_selectedDate!)
                                      : "Henüz tarih seçilmedi",
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime!,
                      );
                      if (newTime != null) {
                        setState(() {
                          _selectedTime = newTime;
                        });
                      }
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Saat Seçimi"),
                                const SizedBox(height: 10),
                                Text(
                                  _selectedTime != null
                                      ? "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}"
                                      : "Henüz saat seçilmedi",
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.book),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: StreamBuilder<List<LessonModel>>(
                                  stream:
                                      context.read<SessionCubit>().lessonList,
                                  builder: (context, state) {
                                    return DropdownButtonFormField<LessonModel>(
                                      hint: const Text("Ders Seçiniz..."),
                                      value: _selectedLesson,
                                      items: state.data
                                          ?.map(
                                            (e) =>
                                                DropdownMenuItem<LessonModel>(
                                              child: Text(e.lessonName),
                                              value: e,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedLesson = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Lütfen bir değer seçiniz';
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitButton(context),
                    child: const Text("Oturum Oluştur"),
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
      String _formattedSelectedDate =
          DateFormat('dd/MM/yyyy').format(_selectedDate!);
      String _formattedSelectedTime =
          "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

      context
          .read<SessionCubit>()
          .createSession(
              _formattedSelectedDate, _formattedSelectedTime, _selectedLesson!)
          .then((value) {
        if (value == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Oturum başarıyla oluşturuldu."),
            backgroundColor: Colors.green,
          ));

          Navigator.of(context).pop();
        }
      });
    }
  }
}
