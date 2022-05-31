import 'dart:developer';
import 'dart:math';

import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/widgets/my_plants_card.widget.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class MyplantsPage extends StatefulWidget {
  const MyplantsPage({Key? key}) : super(key: key);

  @override
  State<MyplantsPage> createState() => _MyplantsPageState();
}

class _MyplantsPageState extends State<MyplantsPage> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
          child: Text(
            'Mes plantes',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
          child: Card(
            elevation: 3,
            child: Container(
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Rechercher ici...',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
            children: [
              FutureBuilder<List<MyPlant>>(
                future: Services.of(context).myPlantsService.getPlants(),
                builder: (context, snapshot) {
                  final plants = (snapshot.data ?? [])
                    ..sort((x, y) => (x.type.intervalMisting > 0
                            ? min(x.remainWatering, x.remainMisting)
                            : x.remainWatering)
                        .compareTo(y.type.intervalMisting > 0
                            ? min(y.remainWatering, y.remainMisting)
                            : y.remainWatering));
                  return Column(
                    children: plants.map(_toPlantWidget).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toPlantWidget(MyPlant plant) {
    return MyPlantCard(
      plant: plant,
    );
  }
}
