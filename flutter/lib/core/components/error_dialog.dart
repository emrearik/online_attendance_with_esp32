import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String title;

  final String? content;
  ErrorDialog({Key? key, this.title = '', required this.content})
      : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();

  static void showErrorDialog(BuildContext dialogContext, dynamic state) {
    showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: ErrorDialog(
              title: state.failure!.code,
              content: state.failure!.message,
            ),
          );
        });
  }
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIosDialog(context)
        : _showAndroidDialog(context);
  }

  Widget _showIosDialog(dialogContext) {
    return CupertinoAlertDialog(
      title: Text(
        widget.title,
      ),
      content: Text(
        widget.content!,
      ),
      actions: [
        CupertinoDialogAction(
            child: const Text("Tamam"),
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop('dialog'))
      ],
    );
  }

  Widget _showAndroidDialog(dialogContext) {
    return AlertDialog(
      title: Text(
        widget.title,
      ),
      content: Text(
        widget.content!,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(dialogContext, rootNavigator: false).pop('dialog');
          },
          child: const Text("Tamam"),
        )
      ],
    );
  }
}
