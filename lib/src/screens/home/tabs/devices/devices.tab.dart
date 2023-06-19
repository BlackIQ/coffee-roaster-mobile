import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DevicesTab extends StatefulWidget {
  const DevicesTab({super.key});

  @override
  State<DevicesTab> createState() => _DevicesTabState();
}

class _DevicesTabState extends State<DevicesTab> {
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  Future<void> _scanForDevices() async {
    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();

      setState(() {
        _devices = devices;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _devices.isNotEmpty
        ? ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              return ListTile(
                title: Text("Hi"),
                subtitle: Text(device.address),
              );
            },
          )
        : const Center(
            child: Text("Sorry, we got an error"),
          );
  }
}
