import 'package:feedy/services/package.service.dart';
import 'package:feedy/services/plant_types.service.dart';
import 'package:feedy/services/storage.service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/services/my_plants.service.dart';

class Services {
  static late final MyPlantsService myPlantsService;
  static late final PlantTypesService plantTypesService;
  static late final StorageService storageService;
  static late final GoTrueClient authService;
  static late final PackageService packageService;

  static void initialize() {
    final client = Supabase.instance.client;
    myPlantsService = MyPlantsService(client);
    plantTypesService = PlantTypesService(client);
    storageService = StorageService();
    authService = client.auth;
    packageService = PackageService();
  }
}
