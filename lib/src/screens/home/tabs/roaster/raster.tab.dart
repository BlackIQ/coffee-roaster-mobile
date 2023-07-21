import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

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

  void roast(lang) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "آیا مایل به ادامه هستید؟",
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
                  "نوع: ${types[selectedType]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "نوع قهوه: ${beans[selectedBean]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                selectedType == 1
                    ? Text(
                        "کشور: ${selectedBean == 0 ? countriesA[selectedCountry] : countriesR[selectedCountry]}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : Container(),
                Text(
                  "نوع رست: ${roasts[selectedRoast]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "وزن قهوه: ${weights[selectedWeigth]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "سایز قهوه: ${sizes[selectedSize]}",
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
              _showSnackBar(context, lang.toast_no_device);
              Navigator.pop(context);
            },
            child: Text(lang.dialog_roast_yes),
          ),
        ],
      ),
    );
  }

  int _index = 0;

  int selectedType = 0;
  List types = ["اسان", "پیشرفته"];

  int selectedBean = 0;
  List beans = ["عربیکا", "ربوستا"];

  int selectedRoast = 0;
  List roasts = ["لایت", "مدیوم", "دارک"];

  int selectedSize = 0;
  List sizes = ["درشت", "متوسط", "ریز"];

  int selectedWeigth = 0;
  List weights = ["100", "150", "200"];

  int selectedCountry = 0;
  List countriesR = ["ویتنام", "برزیل", "اندونزی", "هند", "غیره"];
  List countriesA = [
    "اتیوپی",
    "کلمبیا",
    "گواتمالا",
    "کاستاریکا",
    "برزیل",
    "هند",
    "غیره"
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

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
          roast(lang);
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('نوع'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("نوع را انتخاب کنید"),
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
          title: const Text('نوع قهوه'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("نوع قهوه را انتخاب کنید"),
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
              selectedType == 1
                  ? const Text("کشور را انتخاب کنید")
                  : Container(),
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
          title: const Text('نوع رست'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("نوع رست را انتخاب کنید"),
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
          title: const Text('وزن قهوه'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("وزن قهوه را انتخاب کنید"),
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
          title: const Text('سایز قهوه'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("سایز قهوه را انتخاب کنید"),
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
