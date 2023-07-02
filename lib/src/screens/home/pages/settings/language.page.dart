import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lang.settings_language_title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              lang.settings_language_details,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<Locale>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: GoogleFonts.vazirmatn(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              isExpanded: true,
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
          ],
        ),
      ),
    );
  }
}
