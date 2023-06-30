import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<AppState>(context, listen: true).getLocale;

    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.page_settings_language_title),
        elevation: 1,
      ),
      body: Center(
        child: DropdownButton<Locale>(
          value: locale,
          onChanged: (value) {
            Provider.of<AppState>(context, listen: false).setLocale(
              Locale(value.toString(), ''),
            );
          },
          items: const [
            DropdownMenuItem<Locale>(
              value: Locale('en', ''),
              child: Text('English'),
            ),
            DropdownMenuItem<Locale>(
              value: Locale('fa', ''),
              child: Text('فارسی'),
            ),
          ],
        ),
      ),
    );
  }
}
