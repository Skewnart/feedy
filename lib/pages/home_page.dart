import 'package:flutter/material.dart';
import 'package:feedy/pages/home_pages/myplants_page.dart';
import 'package:feedy/pages/home_pages/search_page.dart';
import 'package:feedy/pages/home_pages/settings_page.dart';
import 'package:feedy/components/auth_required_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends AuthRequiredState<MyHomePage> {
  int _selectedIndex = 1;

  static const List<PageOption> _widgetOptions = <PageOption>[
    PageOption(
      title: "Recherche",
      icon: Icon(Icons.search),
      child: SearchPage(),
    ),
    PageOption(
      title: "Mes plantes",
      icon: Icon(Icons.grass),
      child: MyplantsPage(),
    ),
    PageOption(
      title: "Paramètres",
      icon: Icon(Icons.settings),
      child: SettingsPage(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex).child,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _widgetOptions[0].icon,
            label: _widgetOptions[0].title,
          ),
          BottomNavigationBarItem(
            icon: _widgetOptions[1].icon,
            label: _widgetOptions[1].title,
          ),
          BottomNavigationBarItem(
            icon: _widgetOptions[2].icon,
            label: _widgetOptions[2].title,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class PageOption {
  final String title;
  final Icon icon;
  final Widget child;

  const PageOption(
      {required this.title, required this.icon, required this.child});
}
