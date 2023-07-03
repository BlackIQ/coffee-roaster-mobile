import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  void _showColorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: ListView.separated(
            itemCount: Colors.primaries.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final color = Colors.primaries[index];
              // final colorName = color.toString();

              return ListTile(
                title: Text(
                  "Color ${index + 1}",
                  style: TextStyle(
                    color: color,
                    // color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                trailing: Icon(Icons.brush, color: color),
                onTap: () {
                  Provider.of<AppState>(context, listen: false)
                      .setThemeColor(color);
                },
              );
            },
          ),
        );
      },
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lang.settings_theme_title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              lang.settings_theme_details,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<Brightness>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: GoogleFonts.vazirmatn(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              isExpanded: true,
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
            const SizedBox(
              height: 5,
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              lang.settings_color_title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              lang.settings_color_details,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _showColorBottomSheet(context),
              child: Text(
                lang.settings_color_bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
