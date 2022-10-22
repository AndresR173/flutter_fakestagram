import 'dart:async';

import 'package:flutter/material.dart';

bool _isDialogOpen = false;

Future<T?> showGenericDialogTwoButton<T>(
  BuildContext context,
  String message, {
  String title = 'Information',
  String okButtonLabel = 'Ok',
  Function()? onOkPressed,
  String cancelButtonLabel = 'Cancel',
  Function()? onCancelPressed,
  bool dismissible = true,
  T? okReturnValue,
  T? cancelReturnValue,
}) {
  if (_isDialogOpen) {
    Navigator.pop(context);
  } else {
    _isDialogOpen = true;
  }
  return showDialog<T?>(
    barrierDismissible: dismissible,
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message, textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
          child: Text(okButtonLabel),
          onPressed: () {
            Navigator.pop(context, okReturnValue);
            onOkPressed?.call();
            _isDialogOpen = false;
          },
        ),
        TextButton(
          child: Text(cancelButtonLabel),
          onPressed: () {
            Navigator.pop(context, cancelReturnValue);
            onCancelPressed?.call();
            _isDialogOpen = false;
          },
        )
      ],
    ),
  );
}

Future<T?> showGenericDialog<T>(
  BuildContext context,
  String message, {
  String title = 'Information',
  String continueButtonLabel = 'Ok',
  Function()? onOkPressed,
  T? okReturnValue,
  bool dismissible = true,
}) {
  if (_isDialogOpen) {
    Navigator.pop(context);
  } else {
    _isDialogOpen = true;
  }
  return showDialog<T?>(
    barrierDismissible: dismissible,
    context: context,
    builder: (_) =>
        AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(continueButtonLabel),
              onPressed: () {
                Navigator.pop(context, okReturnValue);
                onOkPressed?.call();
                _isDialogOpen = false;
              },
            ),
          ],
        ),
  );
}

Future<void> showProgressDialog(BuildContext context, {required bool mustShow, bool dismissible = false, int delay = 0}) {
  if (_isDialogOpen) {
    Navigator.pop(context);
  } else {
    _isDialogOpen = true;
  }
  return Future.delayed(Duration(milliseconds: delay), () async {
    if (mustShow) {
      await showDialog(
        useRootNavigator: true,
        barrierDismissible: dismissible,
        context: context,
        builder: (_) => const AlertDialog(
          content: SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 90, right: 90),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  });
}
