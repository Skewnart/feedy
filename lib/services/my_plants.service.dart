import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';

class MyPlantsService {
  static const plants = 'my_plants';
  final SupabaseClient _client;

  MyPlantsService(this._client);

  Future<List<MyPlant>> getPlants() async {
    final response = await _client.from(plants).select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => toPlant(e)).toList();
    }
    print('Error fetching notes: ${response.error!.message}');
    return [];
  }

  MyPlant toPlant(Map<String, dynamic> result) {
    return MyPlant(
        result['id'],
        result['name'],
        PlantType.PlantTypes[result['type'] - 1],
        DateTime.parse(result['last_watering']),
        DateTime.parse(result['last_watering']));
  }
}
