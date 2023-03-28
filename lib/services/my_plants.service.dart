import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedy/services/database.service.dart';
import 'package:feedy/services/services.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';

class MyPlantsService {
  static const tableName = 'plants';

  MyPlantsService();

  Future<List<MyPlant>> getPlants() async {
    final plants =
        await Services.databaseService.getTableContentWithUser(tableName);
    if (plants.isEmpty) return [];

    final types = await Services.plantTypesService.getPlantTypes();
    if (types.isEmpty) return [];

    return plants.map((plant) => toPlant(plant, types)).toList();
  }

  MyPlant toPlant(Map<String, dynamic> result, List<PlantType> types) {
    final plant = MyPlant(
      result['id'],
      result['name'],
      types.firstWhere((type) => type.name == result['plantType']),
      DateTime.fromMillisecondsSinceEpoch(
          (result['last_watering'] as Timestamp).millisecondsSinceEpoch),
      DateTime.fromMillisecondsSinceEpoch(
          (result['last_misting'] as Timestamp).millisecondsSinceEpoch),
      DateTime.fromMillisecondsSinceEpoch(
          (result['acquisition_date'] as Timestamp).millisecondsSinceEpoch),
    );
    return plant;
  }

  Map<String, dynamic> toFirestore(MyPlant plant) {
    return <String, dynamic>{
      'name': plant.name,
      'plantType': plant.type.name,
      'last_watering': Timestamp.fromDate(plant.lastWatering),
      'last_misting': Timestamp.fromDate(plant.lastMisting),
      'acquisition_date': Timestamp.fromDate(plant.acquisitionDate)
    };
  }

  Future<DatabaseMessage> water(MyPlant plant) async {
    plant.lastWatering = DateTime.now();
    return save(plant);
  }

  Future<DatabaseMessage> mist(MyPlant plant) async {
    plant.lastMisting = DateTime.now();
    return save(plant);
  }

  Future<DatabaseMessage> save(MyPlant plant) async {
    return Services.databaseService
        .setDataWithUser(tableName, plant.id, toFirestore(plant));
  }

  Future<DatabaseMessage> delete(MyPlant plant) {
    return Services.databaseService.deleteDataWithUser(tableName, plant.id);
  }
}
