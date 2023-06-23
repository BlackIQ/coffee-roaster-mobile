import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
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

  FlutterBlue flutterBlue = FlutterBlue.instance;

  late StreamSubscription scanSubscription;

  BluetoothDevice? connectedDevice;

  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    try {
      flutterBlue.startScan(timeout: const Duration(seconds: 4));

      scanSubscription = flutterBlue.scanResults.listen((results) {
        setState(() {
          scanResults = results;
        });
      });
    } catch (error) {
      _showSnackBar(context, "I have error");
    }
  }

  final TextEditingController _message = TextEditingController();

  void write() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Communicate'),
        content: TextField(
          controller: _message,
          decoration: const InputDecoration(hintText: "Enter your text"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () async {
              List<BluetoothService>? services =
                  await connectedDevice?.discoverServices();

              services?.first.characteristics.first
                  .write(stringToHex(_message.text));

              // for (var service in services!) {
              //   var characteristics = service.characteristics;

              //   await characteristics[0].write(stringToHex(_message.text));
              // }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  List<int> stringToHex(String input) {
    List<int> bytes = utf8.encode(input);

    return bytes;
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scanResults.isNotEmpty
        ? ListView.separated(
            itemCount: scanResults.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final result = scanResults[index];
              final device = result.device;

              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.id.toString()),
                onTap: () {
                  if (connectedDevice?.id == device.id) {
                    write();
                  } else {
                    _showSnackBar(context, "First, connect to device");
                  }
                },
                trailing: TextButton(
                  onPressed: () async {
                    if (connectedDevice != null &&
                        connectedDevice!.id == device.id) {
                      await connectedDevice!.disconnect();

                      setState(() {
                        connectedDevice = null;
                      });

                      _showSnackBar(
                          context, "Disconnected from ${device.name}");
                    } else {
                      await device.connect();

                      setState(() {
                        connectedDevice = device;
                      });

                      _showSnackBar(
                          context, "Conencted to from ${device.name}");
                    }
                  },
                  child: Text(
                    connectedDevice?.id == device.id ? 'Disconnect' : 'Connect',
                  ),
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
