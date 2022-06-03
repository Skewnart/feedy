import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/plant_type.model.dart';

class PlantTypesService {
  static const plant_types_table = 'plant_types';
  final SupabaseClient _client;

  List<PlantType>? types;

  PlantTypesService(this._client);

  Future<List<PlantType>> getPlantTypes() async {
    if (types == null) {
      final response = await _client.from(plant_types_table).select().execute();
      if (response.error == null) {
        final results = response.data as List<dynamic>;
        types = results.map((e) => toPlantType(e)).toList();
      } else {
        print('Error fetching plant types: ${response.error!.message}');
        return [];
      }
    }
    return types!;
  }

  PlantType toPlantType(Map<String, dynamic> result) {
    return PlantType(
      result['id'],
      result['name'],
      result['image_name'],
      result['interval_watering'],
      result['interval_misting'],
    );
  }
}
