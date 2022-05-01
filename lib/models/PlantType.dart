class PlantType {
  final int id;
  final String name;
  final String image;

  const PlantType(this.id, {required this.name, required this.image});

  static const List<PlantType> PlantTypes = [
    PlantType(1, name: "Monstera", image: 'assets/images/potdefleur7.png'),
    PlantType(2, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(3, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(4, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(5, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(6, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(7, name: "Pilea", image: 'assets/images/potdefleur7.png'),
    PlantType(8, name: "Pilea", image: 'assets/images/potdefleur7.png'),
  ];
}
