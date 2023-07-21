import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:roaster/src/screens/landing.dart';
import 'package:roaster/src/services/state/state.service.dart';

void main() {
  runApp(ChangeNotifierProvider<AppState>(
    create: (_) => AppState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: true);
    final locale = state.getLocale;

    final isPersian = locale.languageCode == 'fa';

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Roaster Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.vazirmatnTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          brightness: state.getTheme,
          seedColor: state.getThemeColor,
          background: state.getTheme == Brightness.dark
              ? Colors.black
              : Colors.grey[50],
        ),
        useMaterial3: true,
      ),
      home: Directionality(
        textDirection: isPersian ? TextDirection.rtl : TextDirection.ltr,
        child: const Landing(),
      ),
    );
  }
}
