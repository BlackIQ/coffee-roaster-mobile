import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

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

  List<int> stringToHex(String input) {
    List<int> bytes = utf8.encode(input);

    return bytes;
  }

  String hexToString(List<int> input) {
    String string = utf8.decode(input);

    return string;
  }

  BluetoothDevice? connectedDevice;

  void getBle(context) {
    BluetoothDevice? ble = Provider.of<AppState>(context, listen: true).getBle;

    setState(() {
      connectedDevice = ble;
    });
  }

  int calculateDoneTime(int selectedWeight) {
    const Map<int, int> weightToTime = {
      0: 750,
      1: 850,
      2: 900,
    };

    return weightToTime[selectedWeight] ?? 0;
  }

  void roast(data, lang) {
    String type = data['types'][selectedType];
    Map bean = data['beans'][selectedBean];
    Map size = data['sizes'][selectedSize];
    Map roast = data['roasts'][selectedRoast];
    Map weight = data['weights'][selectedWeigth];

    int weightTime = data['weights'][selectedWeigth]['seconds'];
    int sizeTime = data['sizes'][selectedSize]['seconds'];
    int beanTime = data['beans'][selectedBean]['seconds'];
    int roastTime = data['roasts'][selectedRoast]['seconds'];

    int doneTime = calculateDoneTime(selectedWeigth);

    // int stepOne = weightTime ~/ 10;
    // int stepTwo = stepOne + sizeTime ~/ 10;
    // int stepThree = stepTwo + beanTime ~/ 10;
    // int stepFour = stepThree + roastTime ~/ 10;
    int stepFive = doneTime - (weightTime + sizeTime + beanTime + roastTime);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          lang.confirm_continue,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Information
                Text(
                  "${lang.step_title_type}: $type",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_bean}: ${bean['label']}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                selectedType == 1
                    ? Text(
                        "${lang.step_title_country}: ${selectedBean == 0 ? data['countriesA'][selectedCountry] : data['countriesR'][selectedCountry]}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : Container(),
                Text(
                  "${lang.step_title_roast}: ${roast['label']}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_weight}: ${weight['label']}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_size}: ${size['label']}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                // const Divider(),
                // // Steps
                // Text(
                //   "${lang.step_trns} 1: 0 -> $stepOne",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
                // Text(
                //   "${lang.step_trns} 2: $stepOne -> $stepTwo",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
                // Text(
                //   "${lang.step_trns} 3: $stepTwo -> $stepThree",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
                // Text(
                //   "${lang.step_trns} 4: $stepThree -> $stepFour",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
                // Text(
                //   "${lang.step_trns} 5: $stepFour -> 900",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
              ],
            ),
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
              Map<String, int> sendObject = {
                "1": weightTime ~/ 10,
                "2": sizeTime ~/ 10,
                "3": beanTime ~/ 10,
                "4": roastTime ~/ 10,
                "5": stepFive ~/ 10,
              };

              // Map<String, int> sendObject = {
              //   "1": 2,
              //   "2": 2,
              //   "3": 2,
              //   "4": 2,
              //   "5": 2,
              // };

              // Map<String, int> sendObject = {
              //   "1": weightTime,
              //   "2": sizeTime,
              //   "3": beanTime,
              //   "4": roastTime,
              //   "5": stepFive,
              // };

              if (connectedDevice != null) {
                try {
                  List<int> sendHex = stringToHex(jsonEncode(sendObject));

                  List<BluetoothService>? services =
                      await connectedDevice?.discoverServices();

                  services?.forEach((service) async {
                    var characteristic = service.characteristics.first;

                    await characteristic.write(sendHex);

                    // characteristic.setNotifyValue(true);

                    // characteristic.value.listen((value) {
                    //   if (value.runtimeType.toString() == "Uint8List") {
                    //     String response = hexToString(value);

                    //     _showSnackBar(context, response);
                    //   }
                    // });

                    // var subscription = characteristic.value.listen((value) {
                    //   if (value.runtimeType.toString() == "Uint8List") {
                    //     String response = hexToString(value);

                    //     _showSnackBar(context, response);
                    //   }
                    // });

                    // subscription.cancel();
                  });
                } catch (e) {
                  _showSnackBar(context, e.toString());
                }
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

  int selectedType = 0;
  int selectedBean = 0;
  int selectedRoast = 0;
  int selectedSize = 0;
  int selectedWeigth = 0;
  int selectedCountry = 0;

  @override
  Widget build(BuildContext context) {
    getBle(context);

    final lang = AppLocalizations.of(context);

    List types = [lang!.step_types_easy, lang.step_types_advanced];

    List beans = [
      {'label': lang.step_beans_a, 'seconds': 420},
      {'label': lang.step_beans_r, 'seconds': 330},
    ];

    List roasts = [
      {'label': lang.step_roast_light, 'seconds': 50},
      {'label': lang.step_roast_medium, 'seconds': 60},
      {'label': lang.step_roast_dark, 'seconds': 80},
    ];

    List sizes = [
      {'label': lang.step_size_coarse, 'seconds': 70},
      {'label': lang.step_size_medium, 'seconds': 50},
      {'label': lang.step_size_tiny, 'seconds': 30},
    ];

    List weights = [
      {'label': '100', 'seconds': 90},
      {'label': '150', 'seconds': 150},
      {'label': '200', 'seconds': 240},
    ];

    List countriesR = [
      lang.country_vietnam,
      lang.country_brazil,
      lang.country_indonesia,
      lang.country_india,
      lang.country_etc
    ];
    List countriesA = [
      lang.country_ethiopia,
      lang.country_columbia,
      lang.country_guatemala,
      lang.country_costarica,
      lang.country_brazil,
      lang.country_india,
      lang.country_etc
    ];

    Map data = {
      "types": types,
      "beans": beans,
      "roasts": roasts,
      "sizes": sizes,
      "weights": weights,
      "countriesR": countriesR,
      "countriesA": countriesA,
    };

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
        if (_index != 4) {
          setState(() {
            _index += 1;
          });
        } else {
          roast(data, lang);
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: Text(lang.step_title_type),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.step_details_type),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedType,
                onChanged: (int? value) {
                  setState(() {
                    selectedType = value ?? 1;
                  });
                },
                items: types.asMap().entries.map((entry) {
                  int index = entry.key;
                  String type = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ],
          ),
          isActive: _index == 0,
        ),
        Step(
          title: Text(lang.step_title_bean),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.step_details_bean),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedBean,
                onChanged: (int? value) {
                  setState(() {
                    selectedBean = value ?? 1;
                  });
                },
                items: beans.map<DropdownMenuItem<int>>((item) {
                  int index = beans.indexOf(item);
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(item['label']),
                  );
                }).toList(),
              ),
              selectedType == 1 ? const SizedBox(height: 20) : Container(),
              selectedType == 1 ? Text(lang.step_details_ciuntry) : Container(),
              selectedType == 1 ? const SizedBox(height: 10) : Container(),
              selectedType == 1
                  ? DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      value: selectedCountry,
                      onChanged: (int? value) {
                        setState(() {
                          selectedCountry = value ?? 1;
                        });
                      },
                      items: selectedBean == 0
                          ? countriesA.asMap().entries.map((entry) {
                              int index = entry.key;
                              String country = entry.value;
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(country),
                              );
                            }).toList()
                          : countriesR.asMap().entries.map((entry) {
                              int index = entry.key;
                              String country = entry.value;
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(country),
                              );
                            }).toList(),
                    )
                  : Container(),
            ],
          ),
          isActive: _index == 1,
        ),
        Step(
          title: Text(lang.step_title_roast),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.step_details_roast),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedRoast,
                onChanged: (int? value) {
                  setState(() {
                    selectedRoast = value ?? 1;
                  });
                },
                items: roasts.map<DropdownMenuItem<int>>((item) {
                  int index = roasts.indexOf(item);
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(item['label']),
                  );
                }).toList(),
              ),
            ],
          ),
          isActive: _index == 2,
        ),
        Step(
          title: Text(lang.step_title_weight),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.step_details_weight),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedWeigth,
                onChanged: (int? value) {
                  setState(() {
                    selectedWeigth = value ?? 1;
                  });
                },
                items: weights.map<DropdownMenuItem<int>>((item) {
                  int index = weights.indexOf(item);
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(item['label']),
                  );
                }).toList(),
              ),
            ],
          ),
          isActive: _index == 3,
        ),
        Step(
          title: Text(lang.step_title_size),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.step_details_size),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedSize,
                onChanged: (int? value) {
                  setState(() {
                    selectedSize = value ?? 1;
                  });
                },
                items: sizes.map<DropdownMenuItem<int>>((item) {
                  int index = sizes.indexOf(item);
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(item['label']),
                  );
                }).toList(),
              ),
            ],
          ),
          isActive: _index == 4,
        ),
      ],
    );
  }
}
