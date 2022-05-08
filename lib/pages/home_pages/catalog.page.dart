import 'package:flutter/material.dart';
import 'package:feedy/widgets/catalog_card.widget.dart';
import 'package:feedy/models/plant_type.model.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
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
            "Catalogue",
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
            return CatalogCard(
              plant_type: PlantType.PlantTypes[index],
            );
          }),
        ),
      ),
    ]);
  }
}
