import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:online_yoklama/core/components/error_dialog.dart';
import 'package:online_yoklama/core/extension/init/theme/page_padding.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/cubit/session_cubit.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';

class UpdateSessionScreenArgs {
  BuildContext context;
  SessionModel session;

  UpdateSessionScreenArgs({
    required this.context,
    required this.session,
  });
}

class AdminUpdateSessionScreen extends StatefulWidget {
  final SessionModel session;
  static const String routeName = "/admin_update_session";

  static Route route({required UpdateSessionScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SessionCubit>(
        create: (context) => SessionCubit(),
        child: AdminUpdateSessionScreen(
          session: args.session,
        ),
      ),
    );
  }

  const AdminUpdateSessionScreen({Key? key, required this.session})
      : super(key: key);

  @override
  State<AdminUpdateSessionScreen> createState() =>
      _AdminUpdateSessionScreenState();
}

class _AdminUpdateSessionScreenState extends State<AdminUpdateSessionScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LessonModel? _selectedLesson;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oturum Düzenle"),
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.code,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Oturum ID"),
                              const SizedBox(height: 10),
                              Text(widget.session.sessionID)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showDatePicker(
                            context: context,
                            initialDate: _selectedDate ??
                                DateFormat("dd/MM/yyyy")
                                    .parse(widget.session.sessionDate),
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
                                      : widget.session.sessionDate,
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
                        initialTime: _selectedTime ??
                            TimeOfDay.fromDateTime(DateFormat("HH:mm")
                                .parse(widget.session.selectedTime)),
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
                                      : widget.session.selectedTime,
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
                                      value: widget.session.selectedLesson,
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
                    child: const Text("Oturum Düzenle"),
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
      String? _formattedSelectedDate;
      String? _formattedSelectedTime;
      if (_selectedDate != null) {
        _formattedSelectedDate =
            DateFormat('dd/MM/yyyy').format(_selectedDate!);
      }

      if (_selectedTime != null) {
        _formattedSelectedTime =
            "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}";
      }

      //herhangi bir seçim yapılmadı. varsayılan session değerleri gönderiliyor.
      if (_formattedSelectedTime != null ||
          _formattedSelectedDate != null ||
          _selectedLesson != null) {
        context
            .read<SessionCubit>()
            .updateSession(
                selectedDate:
                    _formattedSelectedDate ?? widget.session.sessionDate,
                selectedTime:
                    _formattedSelectedTime ?? widget.session.selectedTime,
                oldSession: widget.session,
                selectedLesson:
                    _selectedLesson ?? widget.session.selectedLesson)
            .then((value) {
          if (value == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Oturum başarıyla düzenlendi."),
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
