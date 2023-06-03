import 'package:flutter/material.dart';
import 'package:test/src/screens/auth/auth.screen.dart';
import 'package:test/src/screens/home/home.screen.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool authenticated = true;

  @override
  Widget build(BuildContext context) {
    return authenticated ? const HomeScreen() : const AuthScreen();
  }
}
