import 'dart:async';

import 'package:flutter/material.dart';

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

  Map data = {
    'robusta': {
      'minutes': 8,
      'degree': 200,
    },
    'arabica': {
      'minutes': 10,
      'degree': 180,
    },
  };

  void roast(type) {
    Map bean = data[type.toString().toLowerCase()];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Roasting $type'),
        content: Text(
          "Do you confirm you want to roast your $type for ${bean['minutes']} minutes and ${bean['degree']}°C?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showSnackBar(context, "Operation canceled");
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Maybe later"),
          ),
          TextButton(
            onPressed: () {
              _showSnackBar(context, "Operation started");
              // Data from API
              Timer(const Duration(seconds: 10), () {
                _showSnackBar(context, "Operation done. Your $type is ready");
              });
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          child: const Card(
            elevation: 5,
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Robusta',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Minutes: 10',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () => roast("Robusta"),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          child: const Card(
            elevation: 5,
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arabica',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Minutes: 10',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () => roast("Robusta"),
        ),
      ],
    );
  }
}
