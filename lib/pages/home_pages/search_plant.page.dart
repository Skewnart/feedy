import 'package:flutter/material.dart';
import 'package:feedy/widgets/search_card.widget.dart';
import 'package:feedy/models/plant_type.model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: Text(
            "Recherche",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
      Expanded(
        child: GridView.count(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(PlantType.PlantTypes.length, (index) {
            return SearchPlant(
              plant_type: PlantType.PlantTypes[index],
            );
          }),
        ),
      ),
    ]);
  }
}
