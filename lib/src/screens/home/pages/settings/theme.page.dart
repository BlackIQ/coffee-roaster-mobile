import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  @override
  Widget build(BuildContext context) {
    Brightness theme = Provider.of<AppState>(context, listen: true).getTheme;

    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.page_settings_title_title),
        elevation: 1,
      ),
      body: Center(
        child: DropdownButton<Brightness>(
          value: theme,
          onChanged: (value) {
            Provider.of<AppState>(context, listen: false).setTheme(value!);
          },
          items: [
            DropdownMenuItem<Brightness>(
              value: Brightness.dark,
              child: Text(lang.theme_dark),
            ),
            DropdownMenuItem<Brightness>(
              value: Brightness.light,
              child: Text(lang.theme_light),
            ),
          ],
        ),
      ),
    );
  }
}
