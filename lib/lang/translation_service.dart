import 'package:get/get.dart';
import 'package:voices_of_turkey/lang/en_US.dart';
import 'package:voices_of_turkey/lang/tr_TR.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'tr_TR': tr_TR,
      };

  static String mapLocale() {
    final locale = Get.locale;
    var code = "";
    try {
      code = "${locale!.languageCode}-${locale.countryCode!}";
    } catch (_) {}
    return code;
  }
}
