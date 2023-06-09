import 'dart:math';
import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/widgets/my_plants_card.widget.dart';
import 'package:feedy/services/services.dart';
import 'package:feedy/widgets/search.widget.dart';
import 'package:flutter/material.dart';

class MyplantsPage extends StatefulWidget {
  const MyplantsPage({Key? key}) : super(key: key);

  @override
  State<MyplantsPage> createState() => _MyplantsPageState();
}

class _MyplantsPageState extends State<MyplantsPage> {
  final TextEditingController searchController = TextEditingController();
  List<MyPlant>? plantsList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Mes plantes',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          ),
        ),
        FutureBuilder<int>(
          future: getPlantsCount(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data as int) > 0) {
                return SearchWidget(
                    searchController: searchController,
                    notifyParent: () {
                      setState(() {});
                    });
              } else {
                return const Text("");
              }
            } else if (snapshot.hasError) {
              return Text("Erreur ${snapshot.error}");
            }
            return const Text("...");
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: FutureBuilder<List<MyPlant>>(
              future: loadPlantWithSearch(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final plants = (snapshot.data ?? [])
                    ..sort((x, y) => (x.type.intervalMisting > 0
                            ? min(x.remainWatering, x.remainMisting)
                            : x.remainWatering)
                        .compareTo(y.type.intervalMisting > 0
                            ? min(y.remainWatering, y.remainMisting)
                            : y.remainWatering));
                  if (plants.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vous n'avez pas de plantes ?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "Ajoutez-les depuis le catalogue !",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (buildContext, index) {
                        return MyPlantCard(
                          plant: plants[index],
                          notifyParent: refresh,
                        );
                      },
                      itemCount: plants.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.vertical,
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      "Erreur dans le chargement des données : ${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  refresh() {
    plantsList = null;
    setState(() {});
  }

  Future<List<MyPlant>> loadPlantWithSearch() async {
    plantsList ??= await Services.myPlantsService.getPlants();

    if (plantsList!.isEmpty) {
      return plantsList!;
    } else {
      final plants = <MyPlant>[];
      for (final plant in plantsList!) {
        if ((plant.name
                    ?.toLowerCase()
                    .contains(searchController.text.toLowerCase()) ??
                false) ||
            (plant.type.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))) {
          plants.add(plant);
        }
      }
      return plants;
    }
  }

  Future<int> getPlantsCount() async {
    plantsList ??= await Services.myPlantsService.getPlants();

    return plantsList?.length ?? 0;
  }
}
