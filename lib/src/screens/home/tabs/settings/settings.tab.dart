import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Map<String, dynamic> data = {
    'device': 'EN10',
    'owner': 'Amir',
    'roastes': 10,
    'rostes': 10,
    'roaes': 10,
    'rstes': 10,
    'res': 10,
    'oastes': 10,
    'astes': 10,
    'tes': 10,
    'aste3s': 10,
    'rste32s': 10,
    'roa32stes': 10,
    'resrr': 10,
    're1s': 10,
    'oastes1': 10,
    'ffroastes': 10,
    'roaste8s': 10,
    'rog8989gastes': 10,
    'roaste9s': 10,
    'roashhtes': 10,
    'roastrrres': 10,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final entry = data.entries.toList()[index];
              return ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(entry.key), Text(entry.value.toString())]),
              );
            },
          ),
        ),
      ],
    );
  }
}
