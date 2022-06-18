import 'package:feedy/services/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';

class MyPlantsService {
  static const tableName = 'my_plants';
  final SupabaseClient _client;

  MyPlantsService(this._client);

  Future<List<MyPlant>> getPlants() async {
    final response = await _client.from(tableName).select().execute();
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
    return MyPlant(
      result['id'],
      result['name'],
      types.firstWhere((type) => type.id == result['plant_type_id']),
      DateTime.parse(result['last_watering']),
      DateTime.parse(result['last_misting']),
    );
  }

  Future<PostgrestResponse<dynamic>> water(MyPlant plant) async {
    return (await _client.from(tableName).update({
      'last_watering': DateFormat('yyyy-MM-dd').format(DateTime.now())
    }).match({'id': plant.id}).execute());
  }

  Future<PostgrestResponse<dynamic>> mist(MyPlant plant) async {
    return (await _client.from(tableName).update({
      'last_misting': DateFormat('yyyy-MM-dd').format(DateTime.now())
    }).match({'id': plant.id}).execute());
  }

  Future<PostgrestResponse<dynamic>> save(MyPlant plant) async {
    return (await _client.from(tableName).upsert({
      if (plant.id > 0) 'id': plant.id,
      'name': plant.name,
      'plant_type_id': plant.type.id,
      'last_watering': DateFormat('yyyy-MM-dd').format(plant.lastWatering),
      'last_misting': DateFormat('yyyy-MM-dd').format(plant.lastMisting),
    }).execute());
  }

  Future<PostgrestResponse<dynamic>> delete(MyPlant plant) {
    return _client
        .from(tableName)
        .delete(returning: ReturningOption.representation)
        .match({'id': plant.id}).execute();
  }
}
