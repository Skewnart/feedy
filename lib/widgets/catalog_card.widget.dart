import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/pages/catalog_viewer.page.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class CatalogCard extends StatelessWidget {
  const CatalogCard({Key? key, required this.plantType}) : super(key: key);

  final PlantType plantType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/catalog",
            arguments: CatalogViewerArguments(
              plantType: plantType,
              canAdd: true,
            ));
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FutureBuilder<Image>(
                  future: Services.plantTypesService.getImageFromPlantType(
                    plantType,
                    width: null,
                    height: null,
                    fit: BoxFit.contain,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ),
          Text(
            plantType.name,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
