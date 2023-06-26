import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test/src/screens/landing.dart';
import 'package:test/src/state/state.service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Test Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.vazirmatnTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
          ),
          useMaterial3: true,
        ),
        home: const Landing(),
      ),
    );
  }
}
