import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedy/services/colors.service.dart';
import 'package:feedy/services/app.service.dart';
import 'package:feedy/services/lang.service.dart';
import 'package:feedy/services/plant_types.service.dart';
import 'package:feedy/services/settings.service.dart';
import 'package:feedy/services/storage.service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:feedy/services/my_plants.service.dart';

import 'database.service.dart';

class Services {
  static late final MyPlantsService myPlantsService;
  static late final PlantTypesService plantTypesService;
  static late final StorageService storageService;
  static late final AppService appService;
  static late final ColorService colorService;
  static late final LangService langService;
  static late final DatabaseService databaseService;
  static late final SettingsService settingsService;

  static void initialize() {
    myPlantsService = MyPlantsService();
    plantTypesService = PlantTypesService();
    storageService =
        StorageService(FirebaseStorage.instance, const FlutterSecureStorage());
    appService = AppService();
    colorService = ColorService();
    langService = LangService();
    databaseService = DatabaseService(FirebaseFirestore.instance);
    settingsService = SettingsService();
  }
}
