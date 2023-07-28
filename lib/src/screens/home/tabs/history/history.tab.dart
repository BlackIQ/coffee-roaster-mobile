import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

List histories = [
  {
    'id': 1,
    'name': 'amir',
  },
  {
    'id': 2,
    'name': 'ali',
  },
  {
    'id': 3,
    'name': 'nilo',
  }
];

class _HistoryTabState extends State<HistoryTab> {
  // Future<void> _showSnackBar(BuildContext context, String message) async {
  //   final snackBar = SnackBar(
  //     content: Text(message),
  //     duration: const Duration(seconds: 1),
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    bool isGuest = Provider.of<AppState>(context, listen: true).getGuest;

    return isGuest
        ? Center(
            child: Text(
              lang!.bottom_navigator_history,
            ),
          )
        : ListView.separated(
            itemCount: histories.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(histories[index]['name']),
                onTap: () {},
              );
            },
          );
  }
}
