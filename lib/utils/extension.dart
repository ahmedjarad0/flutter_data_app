import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextHelper on BuildContext {
  void showSnackBar({required String message, bool error = true}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade500 : Colors.green.shade500,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    ));
  }

  AppLocalizations get localization {
    return AppLocalizations.of(this)!;
  }
}
