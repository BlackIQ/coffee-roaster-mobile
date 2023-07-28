import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:roaster/src/services/api/api.service.dart';
import 'package:roaster/src/services/state/state.service.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final DioClient _dioClient = DioClient();

  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<void> changeInformation(context, name, email) async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];

    Map data = {
      'email': email,
      'name': name,
    };

    var response = _dioClient.updateUser(id, data, context);

    response.then((result) {
      if (result.statusCode == 200) {
        _showSnackBar(context, "User updated");
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});
  }

  Future<void> changePassword(context, curPass, newPass, confPass) async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];
    String cur =
        Provider.of<AppState>(context, listen: false).getUser['password'];

    if (cur == generateMd5(curPass)) {
      if (newPass == confPass) {
        Map data = {
          'password': newPass,
        };

        var response = _dioClient.updateUserPassword(id, data, context);

        response.then((result) {
          if (result.statusCode == 200) {
            _showSnackBar(context, "Password updated");
          } else {
            _showSnackBar(context, result.data["message"].toString());
          }
        }).catchError((error) {});
      } else {
        _showSnackBar(
            context, "New password and confirm password is not matched");
      }
    } else {
      _showSnackBar(context, "Current password is not matched");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final lang = AppLocalizations.of(context);

    Map user = Provider.of<AppState>(context, listen: true).getUser;

    final TextEditingController _name = TextEditingController(
      text: user['name'],
    );
    final TextEditingController _email = TextEditingController(
      text: user['email'],
    );

    final TextEditingController _currentPassword = TextEditingController();
    final TextEditingController _newPassword = TextEditingController();
    final TextEditingController _confirmPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Profile"), // TODO: Translate
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Change information",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Change name",
                hintText: "Change name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Change email",
                hintText: "Change email",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeInformation(
                context,
                _name.text,
                _email.text,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text("Change information"),
            ),
            const SizedBox(height: 10),
            Divider(
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 10),
            Text(
              "Change password",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _currentPassword,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Current password",
                hintText: "Current password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _newPassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "New password",
                      hintText: "New password",
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _confirmPassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm password",
                      hintText: "Confirm password",
                    ),
                    obscureText: true,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changePassword(
                context,
                _currentPassword.text,
                _newPassword.text,
                _confirmPassword.text,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Change password"),
            ),
          ],
        ),
      ),
    );
  }
}
