import 'package:flutter/material.dart';
import 'package:feedy/pages/home_pages/my_plants.page.dart';
import 'package:feedy/pages/home_pages/catalog.page.dart';
import 'package:feedy/pages/home_pages/settings.page.dart';
import 'package:feedy/modules/authentication/auth_required_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends AuthRequiredState<MyHomePage> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  static const List<PageOption> _widgetOptions = <PageOption>[
    PageOption(
      title: "Catalogue",
      icon: Icon(Icons.search),
      child: CatalogPage(),
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
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: PageView(
            onPageChanged: (page) {
              setState(() {
                _selectedIndex = page;
              });
            },
            controller: _pageController,
            children: _widgetOptions.map((e) => e.child).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
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
