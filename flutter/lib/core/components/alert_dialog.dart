import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String alertDialogTitle;
  final String alertDialogContent;
  final String continueText;
  final String cancelText;
  final Function() continueAction;
  final Function() cancelAction;
  const AlertDialogWidget(
      {Key? key,
      required this.alertDialogTitle,
      required this.alertDialogContent,
      required this.continueText,
      required this.cancelText,
      required this.continueAction,
      required this.cancelAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? _showAndroidDialog(context)
        : _showIosDialog(context);
  }

  _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertDialogTitle,
      ),
      content: Text(
        alertDialogContent,
      ),
      actions: [
        ElevatedButton(
          child: Text(continueText),
          onPressed: continueAction,
        ),
        ElevatedButton(
          child: Text(cancelText),
          onPressed: cancelAction,
        )
      ],
    );
  }

  Widget _showIosDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        alertDialogTitle,
      ),
      content: Text(
        alertDialogContent,
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(continueText),
          onPressed: continueAction,
        ),
        CupertinoDialogAction(
          child: Text(cancelText),
          onPressed: cancelAction,
        ),
      ],
    );
  }
}
