import 'package:flutter/material.dart';

class MyplantsPage extends StatefulWidget {
  const MyplantsPage({Key? key}) : super(key: key);

  @override
  State<MyplantsPage> createState() => _MyplantsPageState();
}

class _MyplantsPageState extends State<MyplantsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: Text(
            "Mes plantes",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: const [
            Text("Plante 1"),
            Text("Plante 2"),
          ],
        ),
      ),
    ]);
  }
}
