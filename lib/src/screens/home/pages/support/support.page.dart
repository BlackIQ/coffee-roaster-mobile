import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roaster/src/screens/home/pages/support/create.page.dart';
import 'package:roaster/src/screens/home/pages/support/single.page.dart';
import 'package:roaster/src/services/api/api.service.dart';

import 'package:roaster/src/services/state/state.service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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
    getAllTickets();
  }

  bool loading = true;
  List tickets = [];

  Future<void> getAllTickets() async {
    String id = Provider.of<AppState>(context, listen: false).getUser['_id'];

    var response = _dioClient.allTickets(id, context);

    response.then((result) {
      if (result.statusCode == 200) {
        setState(() {
          tickets = result.data;
        });
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
        title: Text(lang!.page_support_title),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateSupportPage(),
              ),
            ),
            tooltip: lang.page_support_add_tooltip,
          )
        ],
      ),
      body: !loading
          ? tickets.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tickets[index]['title']),
                      subtitle: Text(
                        '${tickets[index]['body'].toString().substring(0, 3)}.......',
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleSupportPage(
                            id: tickets[index]['_id'].toString(),
                          ),
                        ),
                      ),
                      trailing: tickets[index]['status'] == 0
                          ? Icon(
                              Icons.done,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : Icon(
                              Icons.done_all,
                              color: Colors.green[800],
                            ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                        color: Theme.of(context).colorScheme.primary);
                  },
                  itemCount: tickets.length,
                )
              : const Center(
                  child: Text("No ticket"),
                )
          : Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
