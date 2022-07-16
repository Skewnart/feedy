import 'package:feedy/models/lang.dart';
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

  var langs = [
    Lang("fr", "Français"),
  ];

  LangService();

  Future<Lang> getLang() async {
    return Services.storageService.getValue("lang").then((lang) =>
        langs.firstWhere((element) => element.code == (lang ?? "fr")));
  }

  Future<void> setLang(Lang? lang) {
    return Services.storageService.setValue("lang", lang?.code ?? "fr");
  }

  Future<String> getLabel(String key) {
    return getLang().then((lang) {
      return dict[lang]![key]!;
    });
  }
}
