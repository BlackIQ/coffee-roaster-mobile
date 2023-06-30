import 'package:flutter/material.dart';
import 'package:roaster/src/screens/home/pages/settings/language.page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    List settings = [
      {
        'title': lang!.tab_settings_lang,
        'page': const LanguageSettings(),
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: settings.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Theme.of(context).colorScheme.primary,
        );
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
