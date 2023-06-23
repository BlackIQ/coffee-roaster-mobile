import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

//   Future<void> info() async {
//     IosDeviceInfo device = await deviceInfo.iosInfo;

// // {
// //     'Device Model': 'R2',
// //     'Device Firmware Version': 'RF-1.4.2',
// //     'Bluetooth Firmware Version': '3.0.0',
// //   }

//     print('iOS Device Info:');
//     print('  name: ${device.name}');
//     print('  systemName: ${device.systemName}');
//     print('  systemVersion: ${device.systemVersion}');
//     print('  model: ${device.model}');
//     print('  isPhysicalDevice: ${device.isPhysicalDevice}');
//   }

  // @override
  // void initState() {
  //   super.initState();
  //   info();
  // }

  Map<String, dynamic> data = {};

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
