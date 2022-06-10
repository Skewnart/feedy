import 'package:feedy/models/plant_type.model.dart';

class MyPlant {
  int id;
  String? name;
  PlantType type;
  DateTime lastWatering;
  DateTime lastMisting;

  late int remainWatering;
  late int remainMisting;

  MyPlant(this.id, this.name, this.type, this.lastWatering, this.lastMisting) {
    resetRemainings();
  }

  void resetRemainings() {
    remainWatering =
        type.intervalWatering - DateTime.now().difference(lastWatering).inDays;
    remainMisting =
        type.intervalMisting - DateTime.now().difference(lastMisting).inDays;
  }
}
