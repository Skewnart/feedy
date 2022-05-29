import 'package:feedy/models/plant_type.model.dart';

class MyPlant {
  final int id;
  final String? name;
  final PlantType type;
  final DateTime lastWatering;
  final DateTime lastMisting;

  MyPlant(this.id, this.name, this.type, this.lastWatering, this.lastMisting);
}
