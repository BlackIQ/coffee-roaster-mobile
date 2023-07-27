import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void login() {
    if (_username.text == 'amir' && _password.text == '200300') {
      Provider.of<AppState>(context, listen: false).setAuthenticated(true);
    } else {
      _showSnackBar(context, 'Wrong username or pasword password');
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<AppState>(context, listen: true).getLocale;

    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.login_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "☕️",
                  style: TextStyle(
                    fontSize: 75,
                  ),
                ),
              ),
              Center(
                child: Text(
                  lang.app_title,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: lang.username_label,
                  hintText: lang.username_placeholder,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: lang.password_label,
                  hintText: lang.password_placeholder,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Text(lang.button_login),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: login,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(lang.button_guest),
              ),
              const SizedBox(height: 40),
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
      ),
    );
  }
}
