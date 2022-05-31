import 'package:feedy/models/plant_type.model.dart';

class MyPlant {
  final int id;
  final String? name;
  final PlantType type;
  final DateTime lastWatering;
  final DateTime lastMisting;

  late final int remainWatering;
  late final int remainMisting;

  MyPlant(this.id, this.name, this.type, this.lastWatering, this.lastMisting) {
    remainWatering =
        type.intervalWatering - DateTime.now().difference(lastWatering).inDays;
    remainMisting =
        type.intervalMisting - DateTime.now().difference(lastMisting).inDays;
  }
}
