import 'package:flutter/material.dart';
import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/kingdoms.dart';
import 'package:kingdomino/player_interaction_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  List<Kingdom> generateListOfNKingdoms(int n) {
    List<String> colors = ['navy', 'grey', 'forest', 'maroon'];
    List<Kingdom> kingdoms = [];
    for (int i = 0; i < n; i++) {
      kingdoms.add(Kingdom(colors[i]));
    }
    if (kingdoms.length == 2) {
      kingdoms.addAll([...kingdoms]);
    }
    kingdoms.shuffle();
    return kingdoms;
  }

  @override
  Widget build(BuildContext context) {
    int numberOfKingdoms = 3;
    int numberOfRounds = 13;
    List<Kingdom> kingdoms = generateListOfNKingdoms(numberOfKingdoms);
    if (numberOfKingdoms == 2) numberOfRounds = 7;
    return MaterialApp(
      title: 'Kingdomino',
      home: Scaffold(
        // ignore: avoid_unnecessary_containers
        body: Container(
          color: Colors.black87,
          child: PlayerInteractionInterface(
            dominoesInTheBox: returnEveryDominoFunction(),
            numberOfRounds: numberOfRounds,
            kingdoms: kingdoms,
            numberOfUniqueKingdoms: numberOfKingdoms,
          ),
        ),
      ),
    );
  }
}
