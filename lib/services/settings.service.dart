import 'package:feedy/models/settings.dart';
import 'package:feedy/services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsService {
  static const tableName = 'plantType';
  Settings? settings;

  SettingsService();

  Future<Settings?> getSettings({bool reset = false}) async {
    if (settings == null || reset) {
      final userData = await Services.databaseService.getUserData();
      if (userData == null) return null;

      settings = toSettings(userData);
    }
    return settings;
  }

  Future<void> setSettings(bool wantsNotification) async {
    String fcmToken = wantsNotification
        ? (await FirebaseMessaging.instance.getToken() ?? "")
        : "";

    Settings settingsSaving = Settings(fcmToken, wantsNotification);
    if (await Services.databaseService.setUserData(settingsSaving)) {
      settings = settingsSaving;
    }
  }

  Settings toSettings(Map<String, dynamic> result) {
    return Settings(result['fcm_token'], result['ask_notification']);
  }
}
