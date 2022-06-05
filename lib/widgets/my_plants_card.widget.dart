import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class MyPlantCard extends StatelessWidget {
  const MyPlantCard({Key? key, required this.plant}) : super(key: key);

  final MyPlant plant;

  @override
  Widget build(BuildContext context) {
    final int wateringDays =
        plant.remainWatering < 0 ? 0 : plant.remainWatering;
    final Color wateringColor = wateringDays == 0
        ? Colors.red
        : (wateringDays <= 2 ? Colors.orange : Colors.green);

    final int mistingDays = plant.remainMisting < 0 ? 0 : plant.remainMisting;
    final Color mistingColor = mistingDays == 0
        ? Colors.red
        : (mistingDays <= 2 ? Colors.orange : Colors.green);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFFFFFFF),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          FutureBuilder<Image>(
            future: Services.plantTypesService.getImageFromPlantType(
              plant.type,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      plant.type.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Nom :',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          plant.name ?? "---",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Arrosage :',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '$wateringDays jour${wateringDays > 1 ? "s" : ""}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: wateringColor),
                        ),
                      ),
                    ],
                  ),
                  if (plant.type.intervalMisting > 0)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Brumisation :',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            '$mistingDays jour${mistingDays > 1 ? "s" : ""}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: mistingColor),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                            )),
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            child: const Text("Arroser"),
                          ),
                        ),
                        if (plant.type.intervalMisting > 0)
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 217, 231, 180)),
                                  foregroundColor: MaterialStateProperty.all(
                                    Colors.lightGreen,
                                  )),
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              child: const Text("Brumiser"),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Color(0xFF898989),
            size: 24,
          ),
        ],
      ),
    );
  }
}
