import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String hexToString(List<int> input) {
    String string = utf8.decode(input);

    return string;
  }

  void roast(id, data, lang) {
    Map bean = data[id];
    final lang = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          lang!.dialog_roast_title(bean['title']),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        content: Text(
          lang.dialog_roast_content(bean['title'], bean['duration'].toString()),
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(lang.dialog_roast_no),
          ),
          TextButton(
            onPressed: () async {
              if (connectedDevice != null) {
                Map sendObject = {
                  "t": 1,
                  "p": bean['pin'],
                  "r": bean['relay'],
                  "d": bean['duration'] * 1000,
                };

                List<int> sendHex = stringToHex(jsonEncode(sendObject));

                List<BluetoothService>? services =
                    await connectedDevice?.discoverServices();

                services?.forEach((service) async {
                  var characteristics = service.characteristics;
                  for (BluetoothCharacteristic c in characteristics) {
                    await c.write(sendHex);

                    await c.setNotifyValue(true);

                    c.value.listen((value) {
                      print("Data ---------");
                      print(value);
                      print(value.runtimeType);
                      print("--------- Data");

                      // print('Received data: ${hexToString(value)}');

                      // if (value == "done") {
                      //   _showSnackBar(context, "OK");
                      //   Navigator.pop(context);
                      // }
                    });
                  }
                });
              } else {
                _showSnackBar(context, lang.toast_no_device);
                Navigator.pop(context);
              }
            },
            child: Text(lang.dialog_roast_yes),
          ),
        ],
      ),
    );
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    getBle(context);

    final lang = AppLocalizations.of(context);

    List data = [
      {
        'title': lang!.bean_robusta,
        'duration': 5,
        'pin': 14,
        'relay': 1,
      },
      {
        'title': lang.bean_arabica,
        'duration': 10,
        'pin': 12,
        'relay': 1,
      },
    ];

    return Stepper(
      currentStep: _index,
      elevation: 10,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < 1) {
          setState(() {
            _index += 1;
          });
        } else {
          roast(1, data, lang);
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('نوع قهوه'),
          content: Container(
            alignment: Alignment.centerRight,
            child: const Text('نوع قهوه را انتخاب کنید'),
          ),
          isActive: _index == 0,
        ),
        Step(
          title: const Text('نوع رست'),
          content: Container(
            alignment: Alignment.centerRight,
            child: const Text('نوع رست را انتخاب کنید'),
          ),
          isActive: _index == 1,
        ),
        Step(
          title: const Text('سایز قهوه'),
          content: Container(
            alignment: Alignment.centerRight,
            child: const Text('سایز قهوه را انتخاب کنید'),
          ),
          isActive: _index == 2,
        ),
        Step(
          title: const Text('وزن قهوه'),
          content: Container(
            alignment: Alignment.centerRight,
            child: const Text('وزن قهوه را انتخاب کنید'),
          ),
          isActive: _index == 3,
        ),
      ],
    );

    // return ListView.builder(
    //   itemCount: data.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     final entry = data[index];

    //     String name =
    //         entry['title'][0].toUpperCase() + entry['title'].substring(1);

    //     return ListTile(
    //       title: GestureDetector(
    //         child: Card(
    //           margin: const EdgeInsets.all(5),
    //           elevation: 1,
    //           child: SizedBox(
    //             child: Padding(
    //               padding: const EdgeInsets.all(20),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     name,
    //                     style: TextStyle(
    //                       color: Theme.of(context).colorScheme.onBackground,
    //                       fontSize: 30,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     lang.roast_duration(entry['duration'].toString()),
    //                     style: TextStyle(
    //                       fontSize: 15,
    //                       color: Theme.of(context).colorScheme.secondary,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         onTap: () => roast(index, data, lang),
    //       ),
    //     );
    //   },
    // );
  }
}
