import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
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
  late DateTime _datetimeWatering;
  late DateTime _datetimeMisting;
  late PlantType _plantType;

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
        ? Services.colorService.lowGauge
        : (wateringDays <= 2
            ? Services.colorService.middleGauge
            : Services.colorService.highGauge);

    final int mistingDays =
        myPlant!.remainMisting < 0 ? 0 : myPlant!.remainMisting;
    final Color mistingColor = mistingDays == 0
        ? Services.colorService.lowGauge
        : (mistingDays <= 2
            ? Services.colorService.middleGauge
            : Services.colorService.highGauge);

    return WillPopScope(
      onWillPop: canGoBack,
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: IconButton(
                      onPressed: () {
                        canGoBack().then((goback) {
                          if (goback) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: FutureBuilder<Image>(
                              future: Services.plantTypesService
                                  .getImageFromPlantType(
                                isEditing! ? _plantType : myPlant!.type,
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    30,
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
                          ),
                          if (!isEditing!)
                            Text(
                              myPlant!.type.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          if (isEditing!)
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: FutureBuilder<List<PlantType>>(
                                future:
                                    Services.plantTypesService.getPlantTypes(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton<PlantType>(
                                      value: _plantType,
                                      elevation: 16,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      onChanged: (PlantType? newValue) {
                                        setState(() {
                                          _plantType = newValue!;
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
                                        theme: const DatePickerTheme(),
                                        onConfirm: (date) {
                                      setState(() {
                                        _datetimeWatering = date;
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.fr);
                                  },
                                  child: Row(children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(_datetimeWatering),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                      : '$wateringDays jour${wateringDays > 1 ? "s" : ""}',
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
                          if ((isEditing! ? _plantType : myPlant!.type)
                                  .intervalMisting >
                              0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Dernière brumisation : ',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                if (!isEditing!)
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(myPlant!.lastMisting),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                if (isEditing!)
                                  GestureDetector(
                                    onTap: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now().subtract(
                                              const Duration(days: 90)),
                                          maxTime: DateTime.now()
                                              .add(const Duration(days: 90)),
                                          theme: const DatePickerTheme(),
                                          onConfirm: (date) {
                                        setState(() {
                                          _datetimeMisting = date;
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.fr);
                                    },
                                    child: Row(children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(_datetimeMisting),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
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
                                      : '$mistingDays jour${mistingDays > 1 ? "s" : ""}',
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              (isEditing! ? _plantType : myPlant!.type)
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
                ],
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
    _plantType = myPlant!.type;
    _datetimeWatering = myPlant!.lastWatering;
    _datetimeMisting = myPlant!.lastMisting;
  }

  void fillBackDatas() {
    myPlant!.name = _nameController.text;
    myPlant!.type = _plantType;
    myPlant!.lastWatering = _datetimeWatering;
    myPlant!.lastMisting = _datetimeMisting;
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
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Color(0xFFFFFFFF),
                ),
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
                  if (myPlant!.id == 0) {
                    myPlant!.id = response.data[0]['id'];
                    Navigator.of(context).pop(myPlant!);
                  }
                  isEditing = false;
                  context.showSnackBar(
                      message: "Informations sauvegardées avec succès !");
                }

                setState(() {
                  saveLoading = false;
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

  Future<bool> canGoBack() async {
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
              context.showErrorSnackBar(message: "La sauvegarde a échouée.");
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
  }
}
