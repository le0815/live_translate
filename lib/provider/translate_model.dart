import 'package:flutter/material.dart';

class TranslateModel with ChangeNotifier { 
  static final TranslateModel instance = TranslateModel._();
  TranslateModel._();

  void setState() {
    notifyListeners();
  }
}