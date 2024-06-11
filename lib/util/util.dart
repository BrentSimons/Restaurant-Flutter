import 'package:flutter/material.dart';

class Util {
  /// Show a simple dialig within [context], with a [title] and [description], and a [image] */
  static void showSimpleDialog(
      BuildContext context, String title, String description,
      {Image? image}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(description),
              if (image != null) image,
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
