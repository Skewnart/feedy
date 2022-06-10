import 'dart:io';

import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
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

  //Charger l'image du bucket si elle n'a pas déjà été téléchargée
  Future<Image> getImageFromPlantType(PlantType type,
      {double? width, double? height, BoxFit? fit}) async {
    String filepath = await Services.storageService.getPath(type.imageName);

    if (!(await File(filepath).exists())) {
      final image =
          await _client.storage.from("plants").download(type.imageName);
      if (image.hasError) {
        print(
            "${type.imageName} non trouvé dans le bucket. Utilisation de l'image par défaut. ${image.error}");
        return Image.asset(
          "assets/images/lambdaImage.png",
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        print("${type.imageName} téléchargée. Ecriture fichier.");
        Services.storageService.writeFile(type.imageName, image.data!);
        return Image.memory(
          image.data!,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else {
      print(
          "${type.imageName} trouvé dans le stockage. Chargement du fichier.");
      return Image.file(
        File(filepath),
        width: width,
        height: height,
        fit: fit,
      );
    }
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
