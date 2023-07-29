import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/services/api/api.service.dart';
import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final DioClient _dioClient = DioClient();

  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLogin = true;

  Future<void> authentication() async {
    Map data = {
      'email': _email.text,
      'password': _password.text,
    };

    var response = isLogin ? _dioClient.login(data) : _dioClient.register(data);

    response.then((result) {
      if (result.statusCode == 200) {
        Provider.of<AppState>(context, listen: false).setAuthenticated(true);
        Provider.of<AppState>(context, listen: false)
            .setUser(result.data["user"]);
        Provider.of<AppState>(context, listen: false)
            .setToken(result.data["token"]);
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});
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
                controller: _email,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: lang.email_label,
                  hintText: lang.email_placeholder,
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
                onPressed: authentication,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Text(isLogin ? lang.button_login : lang.button_register),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                }),
                child: Text(!isLogin
                    ? lang.button_change_login
                    : lang.button_change_register),
              ),
              // const SizedBox(height: 10),
              // TextButton(
              //   onPressed: login,
              //   style: TextButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //   ),
              //   child: Text(lang.button_guest),
              // ),
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
