// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'series_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // La lista de las 5 pantallas
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SeriesScreen(),
    SearchScreen(),
    LibraryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_outlined),
            activeIcon: Icon(Icons.folder_copy),
            label: 'Biblioteca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // Las propiedades de estilo (type, selectedItemColor, etc.)
        // se eliminaron de aquí porque ahora se controlan
        // globalmente en 'app_theme.dart'
      ),
    );
  }
}
