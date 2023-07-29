import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:roaster/src/services/api/api.service.dart';
import 'package:roaster/src/services/state/state.service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  Future<void> getUser(context) async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];

    var response = _dioClient.singleUser(id, context);

    response.then((result) {
      if (result.statusCode == 200) {
        Provider.of<AppState>(context, listen: false).setUser(result.data);
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});
  }

  Future<void> changeInformation(context, name, email) async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];

    final lang = AppLocalizations.of(context);

    Map data = {
      'email': email,
      'name': name,
    };

    var response = _dioClient.updateUser(id, data, context);

    response.then((result) {
      if (result.statusCode == 200) {
        _showSnackBar(context, lang!.page_settings_profile_user_updated);

        getUser(context);
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});
  }

  Future<void> changePassword(context, curPass, newPass, confPass) async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];
    String cur =
        Provider.of<AppState>(context, listen: false).getUser['password'];

    final lang = AppLocalizations.of(context);

    if (cur == generateMd5(curPass)) {
      if (newPass == confPass) {
        Map data = {
          'password': newPass,
        };

        var response = _dioClient.updateUserPassword(id, data, context);

        response.then((result) {
          if (result.statusCode == 200) {
            _showSnackBar(context, lang!.page_settings_profile_pass_updated);

            getUser(context);
          } else {
            _showSnackBar(context, result.data["message"].toString());
          }
        }).catchError((error) {});
      } else {
        _showSnackBar(context, lang!.page_settings_profile_pass_conflict_new);
      }
    } else {
      _showSnackBar(context, lang!.page_settings_profile_pass_conflict_current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    Map user = Provider.of<AppState>(context, listen: true).getUser;

    final TextEditingController name = TextEditingController(
      text: user['name'] ?? "No name",
    );
    final TextEditingController email = TextEditingController(
      text: user['email'],
    );

    final TextEditingController currentPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.page_settings_profile),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lang.page_settings_profile_change_info,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: name,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang.page_settings_profile_field_name,
                hintText: lang.page_settings_profile_field_name,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang.page_settings_profile_field_email,
                hintText: lang.page_settings_profile_field_email,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeInformation(
                context,
                name.text,
                email.text,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(lang.page_settings_profile_submit_info),
            ),
            const SizedBox(height: 10),
            Divider(
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 10),
            Text(
              lang.page_settings_profile_change_password,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: currentPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang.page_settings_profile_field_currentpass,
                hintText: lang.page_settings_profile_field_currentpass,
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
                    controller: newPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: lang.page_settings_profile_field_newpassword,
                      hintText: lang.page_settings_profile_field_newpassword,
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          lang.page_settings_profile_field_confirmpassword,
                      hintText:
                          lang.page_settings_profile_field_confirmpassword,
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
                currentPassword.text,
                newPassword.text,
                confirmPassword.text,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(lang.page_settings_profile_submit_password),
            ),
          ],
        ),
      ),
    );
  }
}
