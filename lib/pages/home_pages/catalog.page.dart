import 'package:feedy/widgets/catalog_card.widget.dart';
import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/widgets/search.widget.dart';
import 'package:flutter/material.dart';
import 'package:feedy/services/services.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late TextEditingController searchController;
  List<PlantType>? planttypeList;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  refresh() {
    planttypeList = null;
    setState(() {});
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
            'Catalogue',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          ),
        ),
        SearchWidget(
            searchController: searchController,
            notifyParent: () {
              setState(() {});
            }),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: FutureBuilder<List<PlantType>>(
              future: loadPlantTypeWithSearch(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final types = (snapshot.data ?? [])
                    ..sort((x, y) => x.name.compareTo(y.name));
                  return Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                    child: GridView.builder(
                      itemCount: types.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return CatalogCard(
                          plantType: types[index],
                        );
                      },
                    ),
                  );
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

  Future<List<PlantType>> loadPlantTypeWithSearch() async {
    planttypeList = await Services.plantTypesService
        .getPlantTypes(reset: planttypeList == null);

    if (planttypeList!.isEmpty) {
      return planttypeList!;
    } else {
      final typeslist = <PlantType>[];
      for (final type in planttypeList!) {
        if (type.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          typeslist.add(type);
        }
      }
      return typeslist;
    }
  }
}
