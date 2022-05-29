import 'package:feedy/models/my_plant.model.dart';
import 'package:feedy/models/my_plant.model.dart';
import 'package:flutter/material.dart';

class MyPlantCard extends StatelessWidget {
  const MyPlantCard({Key? key, required this.plant}) : super(key: key);

  final MyPlant plant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFFFFFFF),
      elevation: 2,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            plant.type.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          (plant.name ?? "sans nom"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            plant.type.name,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Arrosage :',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '1 jour',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Brumisation :',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: Text(
                          '/',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          child: const Text("Arroser"),
                          // style: Theme.of(context).buttonTheme,
                          // options: FFButtonOptions(
                          //   width: 80,
                          //   height: 20,
                          //   color: Theme.of(context).primaryColor,
                          //   textStyle:
                          //       Theme.of(context).textTheme.subtitle2,
                          //   borderSide: BorderSide(
                          //     color: Colors.transparent,
                          //     width: 1,
                          //   ),
                          //   borderRadius: 12,
                          // ),
                        ),
                        TextButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          child: const Text('Brumiser'),
                          // options: FFButtonOptions(
                          //   width: 80,
                          //   height: 20,
                          //   color: Theme.of(context).primaryColor,
                          //   textStyle:
                          //       Theme.of(context).textTheme.subtitle2,
                          //   borderSide: BorderSide(
                          //     color: Colors.transparent,
                          //     width: 1,
                          //   ),
                          //   borderRadius: 12,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Color(0xFF898989),
            size: 24,
          ),
        ],
      ),
    );
  }
}
