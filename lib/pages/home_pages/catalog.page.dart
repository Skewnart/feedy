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
  List<PlantType>? planttype_list;

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
    planttype_list = null;
    setState(() {});
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
            'Catalogue',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
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
                          plant_type: types[index],
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
    planttype_list = await Services.plantTypesService
        .getPlantTypes(reset: planttype_list == null);

    if (planttype_list!.isEmpty) {
      return planttype_list!;
    } else {
      final typeslist = <PlantType>[];
      for (final type in planttype_list!) {
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
