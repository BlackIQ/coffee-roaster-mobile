import 'package:flutter/material.dart';
import 'package:roaster/src/screens/home/pages/settings/language.page.dart';

import 'package:provider/provider.dart';
import 'package:roaster/src/screens/home/pages/settings/profile.page.dart';
import 'package:roaster/src/screens/home/pages/support/support.page.dart';
import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roaster/src/screens/home/pages/settings/theme.page.dart';

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
        'title': lang!.tab_settings_profile,
        'color': Theme.of(context).colorScheme.primary,
        'icon': Icons.person,
        'onTab': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileSettings(),
              ),
            ),
      },
      {
        'title': lang.tab_settings_lang,
        'color': Theme.of(context).colorScheme.primary,
        'icon': Icons.language,
        'onTab': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LanguageSettings(),
              ),
            ),
      },
      {
        'title': lang.tab_settings_theme,
        'color': Theme.of(context).colorScheme.primary,
        'icon': Icons.brush,
        'onTab': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThemeSettings(),
              ),
            ),
      },
      {
        'title': lang.tab_settings_support,
        'color': Theme.of(context).colorScheme.primary,
        'icon': Icons.support_agent,
        'onTab': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SupportPage(),
              ),
            ),
      },
      {
        'title': lang.tab_settings_logout,
        'color': Theme.of(context).colorScheme.error,
        'icon': Icons.logout,
        'onTab': () => Provider.of<AppState>(context, listen: false)
            .setAuthenticated(false),
      },
    ];

    Map user = Provider.of<AppState>(context, listen: true).getUser;

    String avatarText = "";

    for (var element in user['name'].split(" ")) {
      avatarText += element[0];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: CircleAvatar(
              radius: 50,
              child: Text(avatarText),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user['name'],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: settings.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Theme.of(context).colorScheme.primary,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(settings[index]['icon'],
                    color: settings[index]['color']),
                title: Text(
                  settings[index]['title'],
                  style: TextStyle(
                    color: settings[index]['color'],
                  ),
                ),
                onTap: settings[index]['onTab'],
              );
            },
          ),
        ),
        Text(
          "V Beta 1.0.0",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground, fontSize: 10),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
