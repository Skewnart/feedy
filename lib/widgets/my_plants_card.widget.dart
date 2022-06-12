import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/modules/authentication/auth_state.dart';
import 'package:feedy/pages/my_plant_viewer.page.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class MyPlantCard extends StatefulWidget {
  const MyPlantCard({Key? key, required this.plant, required this.notifyParent})
      : super(key: key);

  final Function() notifyParent;
  final MyPlant plant;

  @override
  MyPlantCardState createState() => MyPlantCardState();
}

class MyPlantCardState extends AuthState<MyPlantCard> {
  @override
  Widget build(BuildContext context) {
    final int wateringDays =
        widget.plant.remainWatering < 0 ? 0 : widget.plant.remainWatering;
    final Color wateringColor = wateringDays == 0
        ? Colors.red
        : (wateringDays <= 2 ? Colors.orange : Colors.green);

    final int mistingDays =
        widget.plant.remainMisting < 0 ? 0 : widget.plant.remainMisting;
    final Color mistingColor = mistingDays == 0
        ? Colors.red
        : (mistingDays <= 2 ? Colors.orange : Colors.green);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/plant",
            arguments: MyPlantViewerArguments(
              myPlant: widget.plant,
              directEditing: false,
            )).then((val) {
          widget.notifyParent();
        });
      },
      child: Card(
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
                widget.plant.type,
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
                        widget.plant.type.name,
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
                            widget.plant.name ?? "---",
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
                    if (widget.plant.type.intervalMisting > 0)
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
                                _waterClick();
                              },
                              child: const Text("Arroser"),
                            ),
                          ),
                          if (widget.plant.type.intervalMisting > 0)
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
                                  _mistClick();
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
      ),
    );
  }

  void _waterClick() {
    final name = widget.plant.name ?? widget.plant.type.name;

    context
        .showYesNoQuestion(
            title: "Arrosage imminent", question: "Voulez-vous arroser $name ?")
        .then((accepted) {
      if (accepted) {
        Services.myPlantsService.water(widget.plant).then((response) {
          if (!response.hasError) {
            widget.notifyParent();
            context.showSnackBar(message: "$name a été arrosée avec succès !");
          } else {
            context.showErrorSnackBar(
                message: "$name n'a pas pu être arrosée !");
            print(response.error);
          }
        });
      }
    });
  }

  void _mistClick() {
    final name = widget.plant.name ?? widget.plant.type.name;

    context
        .showYesNoQuestion(
            title: "Brumisation imminente",
            question: "Voulez-vous brumiser $name ?")
        .then((accepted) {
      Services.myPlantsService.mist(widget.plant).then((response) {
        if (!response.hasError) {
          widget.notifyParent();
          context.showSnackBar(message: "$name a été brumisée avec succès !");
        } else {
          context.showErrorSnackBar(
              message: "$name n'a pas pu être brumisée !");
          print(response.error);
        }
      });
    });
  }
}
