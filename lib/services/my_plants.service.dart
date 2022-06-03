import 'package:feedy/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';

class MyPlantsService {
  static const plantstable = 'my_plants';
  final SupabaseClient _client;

  MyPlantsService(this._client);

  Future<List<MyPlant>> getPlants() async {
    final response = await _client.from(plantstable).select().execute();
    final types = await Services.plantTypesService.getPlantTypes();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => toPlant(e, types)).toList();
    }
    print(
        'Erreur dans la récupération des données : ${response.error!.message}');
    return [];
  }

  MyPlant toPlant(Map<String, dynamic> result, List<PlantType> types) {
    for (final type in types) {
      if (type.id == result['plant_type_id']) {
        return MyPlant(
          result['id'],
          result['name'],
          type,
          DateTime.parse(result['last_watering']),
          DateTime.parse(result['last_misting']),
        );
      }
    }
    throw Exception("Type ${result['plant_type_id']} not found");
  }
}
