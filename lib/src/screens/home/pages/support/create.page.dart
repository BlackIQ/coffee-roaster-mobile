import 'package:provider/provider.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roaster/src/services/api/api.service.dart';

import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateSupportPage extends StatefulWidget {
  const CreateSupportPage({super.key});

  @override
  State<CreateSupportPage> createState() => _CreateSupportPageState();
}

class _CreateSupportPageState extends State<CreateSupportPage> {
  final DioClient _dioClient = DioClient();

  Future<void> _showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  bool loading = true;
  List tickets = [];

  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  Future<void> createTicket() async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];

    final lang = AppLocalizations.of(context);

    Map data = {
      "user": id,
      "body": _body.text,
      "title": _title.text,
    };

    var response = _dioClient.createTicket(data, context);

    response.then((result) {
      if (result.statusCode == 200) {
        _showSnackBar(context, lang!.page_support_snack_created);
        Navigator.pop(context);
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(lang!.page_support_add_title),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lang.page_support_add_details,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang.page_support_field_title,
                hintText: lang.page_support_field_title,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _body,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang.page_support_field_details,
                hintText: lang.page_support_field_details,
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: createTicket,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(lang.page_support_button_submit),
            ),
          ],
        ),
      ),
    );
  }
}
