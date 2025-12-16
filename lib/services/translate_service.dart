import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class TranslateService {
  static final TranslateService instance = TranslateService._();
  TranslateService._();
  final Map language = {"vi-VN": "vi", "en-US": "en", "cmn-Hans-CN": "zh-cn"};
  final translator = GoogleTranslator();
  final String apiKey = "AIzaSyCViZg2lvcFllWX9r-LKBiJn-7mdB8-5Qs";
  // Future<String> translate({
  //   required String origLang,
  //   required String transLang,
  //   required String text,
  // }) async {
  //   if (text.isEmpty) {
  //     return Future.value("");
  //   }
  //   log("trans from $origLang to $transLang");
  //   var result = await translator.translate(
  //     text,
  //     from: language[origLang],
  //     to: language[transLang],
  //   );

  //   return result.toString();
  // }

  // Future getAccessToken() async {
  //   List<String> scopes = ["https://www.googleapis.com/auth/cloud-translation"];

  //   String url = "translation.googleapis.com<>";
  //   Map body = {
  //     "sourceLanguageCode": "en",
  //     "targetLanguageCode": "ru",
  //     "contents": ["Dr. Watson, come here!", "Bring me some coffee!"],
  //   };
  //   http.Response client = await auth
  //       .clientViaApiKey(api)
  //       .post(Uri.parse(url), body: jsonEncode(body));

  //   // get access token
  //   // auth.AccessCredentials credentials = await auth
  //   //     .obtainAccessCredentialsViaServiceAccount(
  //   //       auth.ServiceAccountCredentials.fromJson(authorization),
  //   //       scopes,
  //   //       client,
  //   //     );

  //   // client.close();
  //   // return credentials.accessToken.data;
  //   log("asdfs");
  // }

  Future<String> translate({
    required String transLang,
    required String text,
  }) async {
    String url =
        "https://translation.googleapis.com/language/translate/v2?q=$text&target=$transLang&key=$apiKey";

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    // send notification request to each fcmToken in receiverToken
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data["data"]["translations"][0]["translatedText"];
      } else {
        log('Failed to translate: ${response.statusCode}');
        log('Response body: ${response.body}');
        return 'Failed to translate: ${response.statusCode}';
      }
    } catch (e) {
      log('Error translate: $e');
      return 'Failed to translate: $e';
    }
  }
}
