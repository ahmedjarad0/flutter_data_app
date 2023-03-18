import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar(BuildContext context,
      {required String message, bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade500 : Colors.green.shade500,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}
