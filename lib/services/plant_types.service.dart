import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:feedy/models/plant_type.model.dart';

class PlantTypesService {
  static const tableName = 'plantType';
  List<PlantType>? types;

  PlantTypesService();

  Future<List<PlantType>> getPlantTypes({bool reset = false}) async {
    if (types == null || reset) {
      final plantTypes =
          await Services.databaseService.getTableContent(tableName);
      if (plantTypes.isEmpty) return [];

      types = plantTypes.map((e) => toPlantType(e)).toList();
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
        result['image_name'],
        result['interval_watering'],
        result['interval_misting'],
        result['informations']);
  }
}
