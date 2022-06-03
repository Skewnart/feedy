import 'package:feedy/services/plant_types.service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/services/my_plants.service.dart';

class Services {
  static late final MyPlantsService myPlantsService;
  static late final PlantTypesService plantTypesService;
  static late final GoTrueClient authService;

  static void initialize() {
    final client = Supabase.instance.client;
    myPlantsService = MyPlantsService(client);
    plantTypesService = PlantTypesService(client);
    authService = client.auth;
  }
}
