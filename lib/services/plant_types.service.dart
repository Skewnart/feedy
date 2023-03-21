import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/plant_type.model.dart';

class PlantTypesService {
  static const tableName = 'plant_types';
  final SupabaseClient _client;

  List<PlantType>? types;

  PlantTypesService(this._client);

  Future<List<PlantType>> getPlantTypes({bool reset = false}) async {
    if (types == null || reset) {
      final response = await _client.from(tableName).select().execute();
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

  //Charger l'image du bucket si elle n'a pas déjà été téléchargée
  Future<Image> getImageFromPlantType(PlantType type,
      {double? width, double? height, BoxFit? fit}) {
    return Services.storageService.getImageFromName("plants/" + type.imageName,
        width: width, height: height, fit: fit);
  }

  PlantType toPlantType(Map<String, dynamic> result) {
    return PlantType(
      result['id'],
      result['name'],
      result['image_name'],
      result['interval_watering'],
      result['interval_misting'],
      result['informations'],
    );
  }
}
