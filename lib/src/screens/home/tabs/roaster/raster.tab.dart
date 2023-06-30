import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';

class RoasterTab extends StatefulWidget {
  const RoasterTab({super.key});

  @override
  State<RoasterTab> createState() => _RoasterTabState();
}

class _RoasterTabState extends State<RoasterTab> {
  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  BluetoothDevice? connectedDevice;

  void getBle(context) {
    BluetoothDevice? ble = Provider.of<AppState>(context, listen: true).getBle;

    setState(() {
      connectedDevice = ble;
    });
  }

  List<int> stringToHex(String input) {
    List<int> bytes = utf8.encode(input);

    return bytes;
  }

  Map data = {
    'robusta': {
      'duration': 5,
      'pin': 14,
      'relay': 1,
    },
    'arabica': {
      'duration': 10,
      'pin': 12,
      'relay': 1,
    },
    'test': {
      'duration': 5,
      'pin': 15,
      'relay': 0,
    },
  };

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
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Maybe later"),
          ),
          TextButton(
            onPressed: () async {
              if (connectedDevice != null) {
                Map sendObject = {
                  "pin": bean['pin'],
                  "type": bean['relay'] == 1 ? "relay" : 'normal',
                  "duration": bean['duration'] * 1000,
                };

                List<int> sendHex = stringToHex(jsonEncode(sendObject));

                log(jsonEncode(sendObject));

                List<BluetoothService>? services =
                    await connectedDevice?.discoverServices();

                services?.forEach((service) async {
                  var characteristics = service.characteristics;

                  for (BluetoothCharacteristic c in characteristics) {
                    await c.write(sendHex);
                  }
                });

                _showSnackBar(context, "Operation started");
                Navigator.pop(context);
              } else {
                _showSnackBar(context, "First connect to a device");
                Navigator.pop(context);
              }
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getBle(context);

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final entry = data.entries.toList()[index];

        String name = entry.key[0].toUpperCase() + entry.key.substring(1);

        return ListTile(
          title: GestureDetector(
            child: Card(
              elevation: 5,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Duration: ${entry.value['duration']}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      // Text(
                      //   "Degress: ${entry.value['degree']}°C",
                      //   style: const TextStyle(
                      //     fontSize: 15,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () => roast(entry.key),
          ),
        );
      },
    );
  }
}
