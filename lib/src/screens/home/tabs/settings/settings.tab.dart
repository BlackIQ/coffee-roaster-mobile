import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Map<String, dynamic> data = {
    'Device Model': 'R2',
    'Device Firmware Version': 'RF-1.4.2',
    'Bluetooth Firmware Version': '3.0.0',
  };

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        final entry = data.entries.toList()[index];
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key),
              Text(entry.value.toString()),
            ],
          ),
        );
      },
    );
  }
}
