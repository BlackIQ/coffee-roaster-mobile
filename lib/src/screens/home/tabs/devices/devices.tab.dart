import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';

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

  List<ScanResult> scannedResult = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    try {
      flutterBlue.startScan();

      scanSubscription = flutterBlue.scanResults.listen((results) async {
        setState(() {
          scannedResult = results;
        });
      });
    } catch (error) {
      _showSnackBar(context, "I have error");
    }
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scannedResult.isNotEmpty
        ? ListView.separated(
            itemCount: scannedResult.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final device = scannedResult[index].device;

              return ListTile(
                title: Text(device.name),
                subtitle: Text("Mac: ${device.id}"),
                trailing: TextButton(
                  onPressed: () async {
                    if (connectedDevice != null &&
                        connectedDevice!.id == device.id) {
                      await connectedDevice!.disconnect();

                      Provider.of<AppState>(context, listen: false).unsetBle();

                      setState(() {
                        connectedDevice = null;
                      });

                      _showSnackBar(
                          context, "Disconnected from ${device.name}");
                    } else {
                      await device.connect();

                      Provider.of<AppState>(context, listen: false)
                          .setBle(device);

                      setState(() {
                        connectedDevice = device;
                      });

                      _showSnackBar(context, "Conencted to ${device.name}");
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
