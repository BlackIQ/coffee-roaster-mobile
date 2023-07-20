import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/screens/auth/auth.screen.dart';
import 'package:roaster/src/screens/home/home.screen.dart';
import 'package:roaster/src/services/state/state.service.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    bool authenticated =
        Provider.of<AppState>(context, listen: true).getAuthenticated;

    return authenticated ? const HomeScreen() : const AuthScreen();
  }
}
