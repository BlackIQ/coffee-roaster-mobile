import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/src/state/state.service.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    print("Start scanning");

    try {
      flutterBlue.startScan();

      scanSubscription = flutterBlue.scanResults.listen((results) {
        setState(() {
          loading = false;
          scannedResult = results;
        });
      });
    } catch (error) {
      setState(() {
        loading = false;
      });

      // _showSnackBar(context, "I have error");
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Scan devices'),
        elevation: 0,
      ),
      body: !loading
          ? scannedResult.isNotEmpty
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

                            Provider.of<AppState>(context, listen: false)
                                .unsetBle();

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

                            _showSnackBar(
                                context, "Conencted to ${device.name}");
                          }
                        },
                        child: Text(
                          connectedDevice?.id == device.id
                              ? 'Disconnect'
                              : 'Connect',
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No devices found"),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
