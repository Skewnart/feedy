import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
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
                      myPlant!.type,
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
                  Text(
                    myPlant!.type.name,
                    style: Theme.of(context).textTheme.headline3,
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
                      Text(
                        DateFormat('dd/MM/yyyy').format(myPlant!.lastWatering),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Prochain : ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        '$wateringDays jour${wateringDays > 1 ? "s" : ""}',
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dernierère brumisation : ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(myPlant!.lastMisting),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Prochaine : ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        '$mistingDays jour${mistingDays > 1 ? "s" : ""}',
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
                      myPlant!.type.informations ?? "",
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
    );
  }

  void fillDatasPage(MyPlantViewerArguments args) {
    myPlant = args.myPlant;
    isEditing = args.directEditing;

    _nameController.text = myPlant!.name ?? "";
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
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
          tooltip: 'Editer la plante',
          child: const Icon(Icons.edit),
        );
      } else {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              isEditing = false;
              saveLoading = true;
              myPlant!.name = _nameController.text;
              Services.myPlantsService.save(myPlant!).then((response) {
                if (response.hasError) {
                  context.showErrorSnackBar(
                      message: "La sauvegarde a échouée.");
                  print(response.error!.message);
                } else {
                  context.showSnackBar(
                      message: "Plante actualisée avec succès !");
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
