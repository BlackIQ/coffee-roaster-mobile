import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:roaster/src/screens/landing.dart';
import 'package:roaster/src/state/state.service.dart';

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
    final locale = Provider.of<AppState>(context, listen: true).getLocale;
    final isPersian = locale.languageCode == 'fa';

    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fa', ''),
      ],
      title: 'Roaster Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.vazirmatnTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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
