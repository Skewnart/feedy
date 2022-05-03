import 'package:feedy/models/plant_type.model.dart';
import 'package:flutter/material.dart';

class SearchPlant extends StatelessWidget {
  const SearchPlant({Key? key, required this.plant_type}) : super(key: key);

  final PlantType plant_type;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(plant_type.image),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(2),
                alignment: Alignment.bottomCenter,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                ),
                child: Text(
                  plant_type.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   alignment: Alignment.bottomCenter,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: <Color>[
          //         Colors.black.withAlpha(0),
          //         Colors.black12,
          //         Colors.black45
          //       ],
          //     ),
          //   ),
          //   child: Text(
          //     plant_type.name,
          //     style: const TextStyle(color: Colors.white, fontSize: 16.0),
          //   ),
          // ),
        ],
      ),
    );
  }
}
