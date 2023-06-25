import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:test/src/screens/home/tabs/devices/devices.tab.dart';
import 'package:test/src/screens/home/tabs/devices/pages/scan.page.dart';
import 'package:test/src/screens/home/tabs/roaster/raster.tab.dart';
import 'package:test/src/screens/home/tabs/settings/settings.tab.dart';
import 'package:test/src/services/state/state.service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    // DeviceTab(),
    Center(
      child: Text("Devices"),
    ),
    RoasterTab(),
    Center(
      child: Text("Settings"),
    ),
    // SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BluetoothDevice? device =
        Provider.of<AppState>(context, listen: true).getBle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
                device == null ? Icons.bluetooth : Icons.bluetooth_disabled),
            onPressed: () async {
              if (device == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanPage(),
                  ),
                );
              } else {
                await device.disconnect();

                Provider.of<AppState>(context, listen: false).unsetBle();

                _showSnackBar(context, "Disconnected from ${device.name}");
              }
            },
          ),
        ],
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_maker),
            label: 'Roaster',
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanPage(),
            ),
          ); // Provider.of<AppState>(context, listen: false).setAuthenticated(false);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
