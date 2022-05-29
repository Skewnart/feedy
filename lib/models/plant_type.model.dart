class PlantType {
  final int id;
  final String name;
  final String image;
  final int intervalWatering;
  final int intervalMisting;

  const PlantType(this.id,
      {required this.name,
      required this.image,
      required this.intervalWatering,
      required this.intervalMisting});

  static const List<PlantType> PlantTypes = [
    PlantType(
      1,
      name: "Monstera",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 7,
      intervalWatering: 7,
    ),
    PlantType(
      2,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      3,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      4,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      5,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      6,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      7,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
    PlantType(
      8,
      name: "Pilea",
      image: 'assets/images/potdefleur7.png',
      intervalMisting: 0,
      intervalWatering: 7,
    ),
  ];
}
