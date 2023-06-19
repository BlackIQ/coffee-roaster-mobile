import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/src/screens/home/tabs/devices/devices.tab.dart';
import 'package:test/src/screens/home/tabs/roaster/raster.tab.dart';
import 'package:test/src/screens/home/tabs/settings/settings.tab.dart';
import 'package:test/src/services/state/state.service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    RoasterTab(),
    DevicesTab(),
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String theme = Provider.of<AppState>(context, listen: true).getTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(theme == 'light' ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              Provider.of<AppState>(context, listen: false)
                  .setTheme(theme == 'light' ? 'dark' : 'light');
            },
          ),
        ],
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_maker),
            label: 'Roaster',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AppState>(context, listen: false).setAuthenticated(false);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
