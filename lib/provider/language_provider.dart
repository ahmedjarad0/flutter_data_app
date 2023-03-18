import 'package:database/pref/shared_pref.dart';
import 'package:flutter/cupertino.dart';

class LanguageProvider extends ChangeNotifier{
  String language = SharedPerfController().language;
  void changeLanguage(){
    language = language =='en' ? 'ar': 'en';
    SharedPerfController().changeLanguage(langCode: language);
    notifyListeners();
  }
}