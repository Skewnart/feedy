import 'package:flutter/material.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color foregroundColor = Colors.lightGreen,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(this)
            .textTheme
            .bodyText1!
            .copyWith(color: foregroundColor),
      ),
      backgroundColor: const Color.fromARGB(255, 217, 231, 180),
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(
      message: message,
      foregroundColor: Colors.red,
    );
  }

  Future<bool> showYesNoQuestion(
      {required String title, required String question}) async {
    return await showDialog(
        context: this,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(question),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
                child: const Text("Non"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
                child: const Text("Oui"),
              ),
            ],
          );
        });
  }
}
