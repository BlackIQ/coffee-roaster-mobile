import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';

class DeviceTab extends StatefulWidget {
  const DeviceTab({super.key});

  @override
  State<DeviceTab> createState() => _DeviceTabState();
}

class _DeviceTabState extends State<DeviceTab> {
  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    try {
      FlutterBluetoothSerial.instance.startDiscovery().listen((device) {
        print(device);
        // setState(() {
        //   _devices.add(device);
        // });
      });
    } catch (e) {
      _showSnackBar(context, "Fuck");
      print('I got error!');
    }
  }

  Map data = {
    'robusta': {
      'minutes': 8,
      'degree': 200,
    },
    'arabica': {
      'minutes': 10,
      'degree': 180,
    },
  };

  List devices = ["A", "B", "C"];

  void roast(type) {
    Map bean = data[type.toString().toLowerCase()];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Roasting $type'),
        content: Text(
          "Do you confirm you want to roast your $type for ${bean['minutes']} minutes and ${bean['degree']}°C?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showSnackBar(context, "Operation canceled");
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Maybe later"),
          ),
          TextButton(
            onPressed: () {
              _showSnackBar(context, "Operation started");
              // Data from API
              Timer(Duration(seconds: bean['minutes']), () {
                _showSnackBar(context, "Operation done. Your $type is ready");
              });
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: devices.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(devices[index]),
          trailing: TextButton(
            onPressed: () => {},
            child: const Text("Connect"),
          ),
        );
      },
    );
  }
}
