import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/screens/home/pages/settings/language.page.dart';

import 'package:roaster/src/state/state.service.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String dropdownValue = 'en';

  List settings = [
    {
      'title': "Language",
      'page': const LanguageSettings(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: settings.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(settings[index]['title']),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => settings[index]['page'],
            ),
          ),
        );
      },
    );
  }
}

// Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const settings[index]['page'],
//                   ),
//                 )