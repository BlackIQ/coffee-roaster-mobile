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

  void roast(data, lang) {
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
                Text(
                  "${lang.step_title_type}: ${data['types'][selectedType]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_bean}: ${data['beans'][selectedBean]}",
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
                  "${lang.step_title_roast}: ${data['roasts'][selectedRoast]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_weight}: ${data['weights'][selectedWeigth]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "${lang.step_title_size}: ${data['sizes'][selectedSize]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
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
              if (connectedDevice != null) {
                // Map sendObject = {
                //   "t": 1,
                //   "p": 1,
                //   "r": 1,
                //   "d": 10 * 1000,
                // };

                Map sendObject = {
                  "a": 1,
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
                      if (value.runtimeType.toString() == "Uint8List") {
                        String response = hexToString(value);

                        if (response == "done") {
                          Navigator.pop(context);
                          _showSnackBar(context, "OK");
                        }
                      }
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

    List beans = [lang.step_beans_a, lang.step_beans_r];

    List roasts = [
      lang.step_roast_light,
      lang.step_roast_medium,
      lang.step_roast_dark
    ];

    List sizes = [
      lang.step_size_coarse,
      lang.step_size_medium,
      lang.step_size_tiny
    ];

    List weights = ["100", "150", "200"];

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
                items: beans.asMap().entries.map((entry) {
                  int index = entry.key;
                  String bean = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(bean),
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
                items: roasts.asMap().entries.map((entry) {
                  int index = entry.key;
                  String roast = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(roast),
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
                items: weights.asMap().entries.map((entry) {
                  int index = entry.key;
                  String weight = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(weight),
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
                items: sizes.asMap().entries.map((entry) {
                  int index = entry.key;
                  String size = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(size),
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
