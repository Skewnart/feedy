import 'package:feedy/models/plant_type.model.dart';

class MyPlant {
  String id;
  String? name;
  PlantType type;
  DateTime lastWatering;
  DateTime lastMisting;
  DateTime acquisitionDate;

  late int remainWatering;
  late int remainMisting;
  late int possessionDuration;
  late String possessionDurationString;

  MyPlant(this.id, this.name, this.type, this.lastWatering, this.lastMisting,
      this.acquisitionDate) {
    resetRemainings();
  }

  void resetRemainings() {
    remainWatering =
        type.intervalWatering - DateTime.now().difference(lastWatering).inDays;
    remainMisting =
        type.intervalMisting - DateTime.now().difference(lastMisting).inDays;
    possessionDuration = DateTime.now().difference(acquisitionDate).inDays;

    updatePossessionDurationStr();
  }

  void updatePossessionDurationStr() {
    int temp = 0, remain = possessionDuration;
    possessionDurationString = "";

    if (remain >= 365) {
      temp = (remain / 365).truncate();
      remain %= 365;
      possessionDurationString = "$temp an${temp > 1 ? "s" : ""}";
    }

    if (remain >= 30) {
      temp = (remain / 30).truncate();
      remain %= 30;
      if (possessionDurationString.isNotEmpty) {
        possessionDurationString += ", ";
      }
      possessionDurationString += "$temp mois";
    }

    if (remain >= 1) {
      if (possessionDurationString.isNotEmpty) {
        possessionDurationString += ", ";
      }
      possessionDurationString += "$remain jour${remain > 1 ? "s" : ""}";
    }

    if (possessionDurationString.isEmpty) {
      possessionDurationString = remain == 0 ? "aujourd'hui" : "non possédé";
    }
  }
}
