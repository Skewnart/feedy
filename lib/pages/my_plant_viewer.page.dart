import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MyPlantViewerArguments {
  final MyPlant myPlant;
  final bool directEditing;

  MyPlantViewerArguments({required this.myPlant, required this.directEditing});
}

class MyPlantViewerPage extends StatefulWidget {
  const MyPlantViewerPage({Key? key}) : super(key: key);

  @override
  State<MyPlantViewerPage> createState() => _MyPlantViewerPageState();
}

class _MyPlantViewerPageState extends State<MyPlantViewerPage> {
  final TextEditingController _nameController = TextEditingController();
  late DateTime _datetime_watering;
  late DateTime _datetime_misting;
  late PlantType _planttype;

  MyPlant? myPlant;
  bool? isEditing;

  bool saveLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (myPlant == null) {
      fillDatasPage(
          ModalRoute.of(context)!.settings.arguments as MyPlantViewerArguments);
    }

    final int wateringDays =
        myPlant!.remainWatering < 0 ? 0 : myPlant!.remainWatering;
    final Color wateringColor = wateringDays == 0
        ? Colors.red
        : (wateringDays <= 2 ? Colors.orange : Colors.green);

    final int mistingDays =
        myPlant!.remainMisting < 0 ? 0 : myPlant!.remainMisting;
    final Color mistingColor = mistingDays == 0
        ? Colors.red
        : (mistingDays <= 2 ? Colors.orange : Colors.green);

    return WillPopScope(
      onWillPop: () async {
        if (!isEditing!) {
          return true;
        } else {
          return context
              .showYesNoQuestion(
                  title: "Modification en cours",
                  question: "Voulez-vous sauvegarder ?")
              .then((accepted) {
            if (accepted) {
              fillBackDatas();
              return Services.myPlantsService.save(myPlant!).then((response) {
                if (response.hasError) {
                  context.showErrorSnackBar(
                      message: "La sauvegarde a échouée.");
                  return false;
                } else {
                  context.showSnackBar(
                      message: "Informations sauvegardées avec succès !");
                  return true;
                }
              });
            } else {
              return true;
            }
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    FutureBuilder<Image>(
                      future: Services.plantTypesService.getImageFromPlantType(
                        isEditing! ? _planttype : myPlant!.type,
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!;
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return const SizedBox(
                          height: 150,
                          width: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                    if (!isEditing!)
                      Text(
                        myPlant!.type.name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    if (isEditing!)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: FutureBuilder<List<PlantType>>(
                          future: Services.plantTypesService.getPlantTypes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<PlantType>(
                                value: _planttype,
                                elevation: 16,
                                icon: const Icon(Icons.arrow_drop_down),
                                onChanged: (PlantType? newValue) {
                                  setState(() {
                                    _planttype = newValue!;
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<PlantType>>(
                                        (PlantType type) {
                                  return DropdownMenuItem<PlantType>(
                                    value: type,
                                    child: Text(type.name),
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Text("Chargement...");
                            }
                          },
                        ),
                      ),
                    if (!isEditing!)
                      Text(
                        myPlant!.name ?? "",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    if (isEditing!)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              labelText: 'Nom de la plante'),
                        ),
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dernier arrosage : ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        if (!isEditing!)
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(myPlant!.lastWatering),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        if (isEditing!)
                          GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now()
                                      .subtract(const Duration(days: 90)),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 90)),
                                  theme: DatePickerTheme(), onConfirm: (date) {
                                setState(() {
                                  _datetime_watering = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.fr);
                            },
                            child: Row(children: [
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(_datetime_watering),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ]),
                          ),
                      ],
                    ),
                    if (!isEditing!)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Prochain : ',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            wateringDays == 0
                                ? "Maintenant"
                                : '$wateringDays jours',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: wateringColor),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    if ((isEditing! ? _planttype : myPlant!.type)
                            .intervalMisting >
                        0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dernierère brumisation : ',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          if (!isEditing!)
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(myPlant!.lastMisting),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          if (isEditing!)
                            GestureDetector(
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now()
                                        .subtract(const Duration(days: 90)),
                                    maxTime: DateTime.now()
                                        .add(const Duration(days: 90)),
                                    theme: DatePickerTheme(),
                                    onConfirm: (date) {
                                  setState(() {
                                    _datetime_misting = date;
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.fr);
                              },
                              child: Row(children: [
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(_datetime_misting),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ]),
                            ),
                        ],
                      ),
                    if (!isEditing! && myPlant!.type.intervalMisting > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Prochaine : ',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            mistingDays == 0
                                ? "Maintenant"
                                : '$mistingDays jours',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: mistingColor),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        (isEditing! ? _planttype : myPlant!.type)
                                .informations ??
                            "",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: generateFloatingButton(),
      ),
    );
  }

  void fillDatasPage(MyPlantViewerArguments args) {
    myPlant = args.myPlant;
    isEditing = args.directEditing;

    _nameController.text = myPlant!.name ?? "";
    _planttype = myPlant!.type;
    _datetime_watering = myPlant!.lastWatering;
    _datetime_misting = myPlant!.lastMisting;
  }

  void fillBackDatas() {
    myPlant!.name = _nameController.text;
    myPlant!.type = _planttype;
    myPlant!.lastWatering = _datetime_watering;
    myPlant!.lastMisting = _datetime_misting;
    myPlant!.resetRemainings();
  }

  Widget generateFloatingButton() {
    if (saveLoading) {
      return const FloatingActionButton(
        onPressed: null,
        tooltip: 'Sauvegarde en cours...',
        child: Icon(Icons.pending),
      );
    } else {
      if (!isEditing!) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (myPlant!.id > 0)
              FloatingActionButton(
                onPressed: () {
                  context
                      .showYesNoQuestion(
                          title: "Confirmation",
                          question: "Voulez-vous supprimer la plante ?")
                      .then((acc) {
                    if (acc) {
                      context
                          .showYesNoQuestion(
                              title: "Confirmation", question: "Vraiment ?")
                          .then((accepted) async {
                        if (accepted) {
                          final response =
                              await Services.myPlantsService.delete(myPlant!);
                          if (response.hasError ||
                              (response.data as List<dynamic>).isEmpty) {
                            context.showErrorSnackBar(
                                message: "La suppression n'a pas fonctionné !");
                          } else {
                            context.showSnackBar(
                                message:
                                    "La suppression a fonctionné avec succès !");
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    }
                  });
                },
                tooltip: 'Supprimer la plante',
                backgroundColor: Color.fromARGB(255, 207, 45, 34),
                child: const Icon(Icons.delete),
              ),
            Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 20,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  tooltip: 'Editer la plante',
                  child: const Icon(Icons.edit),
                )),
          ],
        );
      } else {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              saveLoading = true;
              fillBackDatas();
              Services.myPlantsService.save(myPlant!).then((response) {
                if (response.hasError) {
                  context.showErrorSnackBar(
                      message: "La sauvegarde a échouée.");
                  print(response.error!.message);
                } else {
                  isEditing = false;
                  context.showSnackBar(
                      message: "Informations sauvegardées avec succès !");
                }

                setState(() {
                  this.saveLoading = false;
                });
              });
            });
          },
          tooltip: 'Sauvegarder',
          child: const Icon(Icons.save),
        );
      }
    }
  }
}
