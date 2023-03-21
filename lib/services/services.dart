import 'package:feedy/services/colors.service.dart';
import 'package:feedy/services/app.service.dart';
import 'package:feedy/services/lang.service.dart';
import 'package:feedy/services/plant_types.service.dart';
import 'package:feedy/services/storage.service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/services/my_plants.service.dart';

class Services {
  static late final MyPlantsService myPlantsService;
  static late final PlantTypesService plantTypesService;
  static late final StorageService storageService;
  static late final GoTrueClient authService;
  static late final AppService appService;
  static late final ColorService colorService;
  static late final LangService langService;

  static void initialize() {
    final client = Supabase.instance.client;
    myPlantsService = MyPlantsService(client);
    plantTypesService = PlantTypesService(client);
    storageService =
        StorageService(FirebaseStorage.instance, const FlutterSecureStorage());
    authService = client.auth;
    appService = AppService();
    colorService = ColorService();
    langService = LangService();
  }
}
