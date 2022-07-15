import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/pages/my_plant_viewer.page.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class CatalogViewerArguments {
  final PlantType plantType;
  final bool canAdd;

  CatalogViewerArguments({required this.plantType, required this.canAdd});
}

class CatalogViewerPage extends StatefulWidget {
  const CatalogViewerPage({Key? key}) : super(key: key);

  @override
  State<CatalogViewerPage> createState() => _CatalogViewerPageState();
}

class _CatalogViewerPageState extends State<CatalogViewerPage> {
  PlantType? plantType;
  bool? canAdd;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (plantType == null) {
      fillDatasPage(
          ModalRoute.of(context)!.settings.arguments as CatalogViewerArguments);
    }

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
                        future:
                            Services.plantTypesService.getImageFromPlantType(
                          plantType!,
                          width: MediaQuery.of(context).size.width * 0.5 - 30,
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
                    Text(
                      plantType!.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Arrosage tous les ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          plantType!.intervalWatering.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          ' jour${plantType!.intervalWatering > 1 ? "s" : ""}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (plantType!.intervalMisting > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Brumisation tous les ',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            plantType!.intervalMisting.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            ' jour${plantType!.intervalMisting > 1 ? "s" : ""}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        plantType!.informations ?? "",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
        ),
      ),
      floatingActionButton: (canAdd! ? generateFloatingButton() : null),
    );
  }

  void fillDatasPage(CatalogViewerArguments args) {
    plantType = args.plantType;
    canAdd = args.canAdd;
  }

  Widget generateFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        context
            .showYesNoQuestion(
                title: "Confirmation",
                question: "Voulez-vous ajouter cette plante à votre liste ?")
            .then((acc) {
          if (acc) {
            Navigator.pushNamed(context, "/plant",
                arguments: MyPlantViewerArguments(
                  myPlant: MyPlant(0, null, plantType!, DateTime.now(),
                      DateTime.now(), DateTime.now()),
                  directEditing: true,
                )).then((ret) {
              if (ret != null) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      },
      tooltip: 'Ajouter la plante',
      child: const Icon(Icons.shopping_cart),
    );
  }
}
