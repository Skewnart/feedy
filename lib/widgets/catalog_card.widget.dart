import 'package:feedy/models/plant_type.model.dart';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';

class CatalogCard extends StatelessWidget {
  const CatalogCard({Key? key, required this.plant_type}) : super(key: key);

  final PlantType plant_type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder<Image>(
              future: Services.plantTypesService.getImageFromPlantType(
                plant_type,
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
        Text(
          plant_type.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
