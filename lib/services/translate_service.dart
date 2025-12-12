

import 'dart:developer';

import 'package:translator/translator.dart';

class TranslateService {
  static final TranslateService instance = TranslateService._();
  TranslateService._();
  final Map language = {"vi-VN" : "vi", "en-US" : "en", "cmn-Hans-CN" : "zh-cn"};
  final translator = GoogleTranslator();

  Future<String> translate({
    required String origLang,
    required String transLang,
    required String text,
  }) async {
    if(text.isEmpty) {return Future.value("");}
    log("trans from $origLang to $transLang");
    var result = await translator.translate(
      text,
      from: language[origLang],
      to: language[transLang],
    );

    return result.toString();
  }
}
