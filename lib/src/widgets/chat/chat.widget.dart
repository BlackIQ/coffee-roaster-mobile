import 'package:flutter/material.dart';

class ChatContainer extends StatelessWidget {
  final String text;
  final Color fgcolor;
  final Color bgcolor;
  final String side;

  const ChatContainer({
    Key? key,
    required this.text,
    required this.fgcolor,
    required this.bgcolor,
    required this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(13),
          topLeft: const Radius.circular(13),
          bottomLeft: Radius.circular(side == "right" ? 13 : 0),
          bottomRight: Radius.circular(side == "left" ? 13 : 0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: 20,
        ),
        child: Text(
          text,
          style: TextStyle(color: fgcolor),
        ),
      ),
    );
  }
}
