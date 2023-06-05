import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/src/services/state/state.service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void hi() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Username is ${_username.text}'),
        content: const Text('Do you confirm your username?'),
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<AppState>(context, listen: false)
                    .setAuthenticated(true);
                Navigator.pop(context);
              },
              child: const Text("Ok")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("No"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login to your account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Username"),
                hintText: "Enter your username",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Password"),
                  hintText: "Enter your password",
                ),
                obscureText: true),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: hi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text("Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
