import 'package:flutter/material.dart';

class RoasterTab extends StatelessWidget {
  const RoasterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Roaster',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Card(
          elevation: 50,
          shadowColor: Colors.black,
          // color: Colors.greenAccent[100],
          child: SizedBox(
            width: 300,
            height: 500,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Robusta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Robusta coffee is made from the beans, or seeds, of the Coffea canephora plant. Robusta beans are a common sight in coffee blends since their dominantly bitter flavors may be less desirable on their own. Producers often use robusta beans to make pre-ground or instant coffees because they complement many blends.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Card(
          elevation: 50,
          shadowColor: Colors.black,
          // color: Colors.greenAccent[100],
          child: SizedBox(
            width: 300,
            height: 500,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Robusta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Robusta coffee is made from the beans, or seeds, of the Coffea canephora plant. Robusta beans are a common sight in coffee blends since their dominantly bitter flavors may be less desirable on their own. Producers often use robusta beans to make pre-ground or instant coffees because they complement many blends.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
