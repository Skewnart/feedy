import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/pages/my_plant_viewer.page.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CatalogViewerArguments {
  final PlantType plantType;

  CatalogViewerArguments({required this.plantType});
}

class CatalogViewerPage extends StatefulWidget {
  const CatalogViewerPage({Key? key}) : super(key: key);

  @override
  State<CatalogViewerPage> createState() => _CatalogViewerPageState();
}

class _CatalogViewerPageState extends State<CatalogViewerPage> {
  PlantType? plantType;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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
                      plantType!,
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
                    plantType!.name,
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
                  Container(
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
        ),
      ),
      floatingActionButton: generateFloatingButton(),
    );
  }

  void fillDatasPage(CatalogViewerArguments args) {
    plantType = args.plantType;
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
                  myPlant: MyPlant(
                      0, null, plantType!, DateTime.now(), DateTime.now()),
                  directEditing: true,
                ));
          }
        });
      },
      tooltip: 'Ajouter la plante',
      child: const Icon(Icons.shopping_cart),
    );
  }
}