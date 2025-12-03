// import 'package:googleapis/translate/v2.dart';
// import 'package:googleapis_auth/auth_io.dart';

// class TranslationService {
//   final AutoRefreshingAuthClient client;
//   late TranslateApi _translateApi;

//   TranslationService(this.client) {
//     _translateApi = TranslateApi(client);
//   }

//   Future<String> translate(String text, String targetLanguage) async {
//     if (text.isEmpty) return '';
//     try {
//       final response = await _translateApi.translations.list([
//         text,
//       ], target: targetLanguage);
//       if (response.translations != null && response.translations!.isNotEmpty) {
//         return response.translations!.first.translatedText ?? '';
//       }
//       return '';
//     } catch (e) {
//       print('Translation error: $e');
//       return text;
//     }
//   }
// }
