import 'package:flutter/material.dart';

class HorseRow extends StatelessWidget {
  final String name;
  final String race;
  final String age;
  final String robe;
  final String sexe;

  const HorseRow(
      {super.key,
      required this.name,
      required this.race,
      required this.age,
      required this.robe,
      required this.sexe});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Row(children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const Icon(Icons.phone),
          ),
          Column(children: [
            Text(name),
            Text(race),
            Text(age),
            Text(robe),
            Text(sexe)
          ]),
        ])
      ],
    ));
  }
}
