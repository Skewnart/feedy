import 'package:feedy/services/services.dart';

class LangService {
  var dict = {
    "fr": {
      "titleplants": "Mes plantes",
    },
    "en": {
      "titleplants": "My plants",
    },
  };

  var langs = {
    "fr": "Français",
    "en": "English",
  };

  LangService();

  Future<String> getLang() async {
    return Services.storageService
        .getValue("lang")
        .then((lang) => lang ?? "fr");
  }

  Future<void> setLang(String lang) {
    return Services.storageService.setValue("lang", lang);
  }

  Future<String> getLabel(String key) {
    return getLang().then((lang) {
      return dict[lang]![key]!;
    });
  }
}
