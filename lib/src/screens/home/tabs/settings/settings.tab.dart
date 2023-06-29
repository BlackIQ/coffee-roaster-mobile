import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Map<String, dynamic> data = {};

  Map bleSettinfs = {};

  void setBleSettinfs() {
    BluetoothDevice? ble = Provider.of<AppState>(context, listen: true).getBle;

    setState(() {
      bleSettinfs = {
        "Bluetooth Name": ble?.name,
        "Bluetooth ID": ble?.id,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    setBleSettinfs();

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
