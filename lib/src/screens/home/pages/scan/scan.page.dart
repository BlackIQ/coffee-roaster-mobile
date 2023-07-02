import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:roaster/src/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.page_scan_title),
        elevation: 1,
      ),
      body: !loading
          ? scannedResult.isNotEmpty
              ? ListView.separated(
                  itemCount: scannedResult.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    final device = scannedResult[index].device;

                    return ListTile(
                      title: Text(
                        device.name != "" ? device.name : "N/A",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontStyle: device.name == ""
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                      subtitle: Text(
                        "Mac: ${device.id}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
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
                              ? lang.ble_button_disconnect
                              : lang.ble_button_connect,
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    lang.page_scan_no_device,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                )
          : Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
