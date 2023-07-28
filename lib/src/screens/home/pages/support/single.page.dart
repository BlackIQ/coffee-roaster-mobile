import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:roaster/src/services/api/api.service.dart';
import 'package:roaster/src/widgets/chat/chat.widget.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleSupportPage extends StatefulWidget {
  const SingleSupportPage({super.key, this.id});

  final dynamic id;

  @override
  State<SingleSupportPage> createState() => _SingleSupportPageState();
}

class _SingleSupportPageState extends State<SingleSupportPage> {
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
    getSingleTicket();
  }

  bool loading = true;
  Map ticket = {};
  double rate = 3;

  Future<void> getSingleTicket() async {
    var response = _dioClient.singleTicket(widget.id, context);

    response.then((result) {
      if (result.statusCode == 200) {
        setState(() {
          ticket = result.data;
        });
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});

    setState(() {
      loading = false;
    });
  }

  Future<void> rateTicket() async {
    Map data = {
      'rate': rate,
    };

    var response = _dioClient.rateTicket(widget.id, data, context);

    response.then((result) {
      if (result.statusCode == 200) {
        _showSnackBar(context, "Rated!");

        getSingleTicket();
      } else {
        _showSnackBar(context, result.data["message"].toString());
      }
    }).catchError((error) {});

    setState(() {
      loading = false;
    });
  }

  String parseMongoDbTimestamp(String timestamp) {
    // Split the timestamp into date and time parts
    List<String> dateTimeParts = timestamp.split("T");
    String datePart = dateTimeParts[0]; // e.g., "2023-07-28"
    String timePart = dateTimeParts[1]; // e.g., "12:34:56.789Z"

    // Extract year, month, and day from the date part
    List<String> dateParts = datePart.split("-");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Extract hour and minute from the time part
    List<String> timeParts = timePart.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Format the output string as desired (Year Month Day | Hour Minute)
    String formattedDateTime =
        '$year/${_twoDigits(month)}/${_twoDigits(day)} ${_twoDigits(hour)}:${_twoDigits(minute)}';

    return formattedDateTime;
  }

  String _twoDigits(int n) {
    // Helper function to ensure two digits for month, day, hour, and minute
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  @override
  Widget build(BuildContext context) {
    // final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(!loading ? ticket['title'] : "Loading"),
        elevation: 1,
      ),
      body: !loading
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Ticket issues at",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    parseMongoDbTimestamp(ticket['createdAt']),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  ChatContainer(
                    text: ticket['body'],
                    side: "right",
                    fgcolor: Theme.of(context).colorScheme.onPrimary,
                    bgcolor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  ticket['status'] == 2
                      ? ChatContainer(
                          text: ticket['answer'],
                          side: "left",
                          fgcolor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          bgcolor:
                              Theme.of(context).colorScheme.primaryContainer,
                        )
                      : Container(),
                  const Expanded(child: SizedBox(height: 5)),
                  ticket['status'] == 2
                      ? Center(
                          child: Text(
                            "Rate this support!",
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontSize: 20,
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 15),
                  ticket['status'] == 2
                      ? Center(
                          child: !ticket['isRated']
                              ? RatingBar.builder(
                                  itemSize: 30,
                                  initialRating: 3,
                                  minRating: 1,
                                  glowColor: Colors.yellow[600],
                                  unratedColor: Colors.yellow[200],
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      rate = rating;
                                    });
                                  },
                                )
                              : const Text("You rated thick ticket before!"),
                        )
                      : Container(),
                  const SizedBox(height: 15),
                  ticket['status'] == 2
                      ? !ticket['isRated']
                          ? ElevatedButton(
                              onPressed: rateTicket,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.yellow[800],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Rate"),
                            )
                          : Container()
                      : Container(),
                ],
              ),
            )
          : Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
