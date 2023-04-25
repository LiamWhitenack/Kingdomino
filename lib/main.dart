import 'package:flutter/material.dart';
import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/player_interaction_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino',
      home: Scaffold(
        // ignore: avoid_unnecessary_containers
        body: Container(
          color: Colors.blueAccent,
          child: PlayerInteractionInterface(dominoesInTheBox: returnEveryDominoFunction()),
        ),
      ),
    );
  }
}
