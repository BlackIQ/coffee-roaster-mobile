import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/screens/home/pages/scan/scan.page.dart';
import 'package:roaster/src/screens/home/tabs/roaster/raster.tab.dart';
import 'package:roaster/src/screens/home/tabs/settings/settings.tab.dart';
import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    RoasterTab(),
    SettingsTab(),
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

    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.app_title),
        elevation: 1,
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
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.coffee_maker),
            label: lang.bottom_navigator_roaster,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: lang.bottom_navigator_settings,
          ),
        ],
      ),
    );
  }
}
