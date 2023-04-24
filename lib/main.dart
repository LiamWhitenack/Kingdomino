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
        // appBar: AppBar(
        //   title: const Text('Kingdomino'),
        //   backgroundColor: const Color.fromRGBO(149, 107, 169, 1),
        // ),
        body: Container(child: PlayerInteractionInterface(dominoesInTheBox: returnEveryDominoFunction())),
      ),
    );
  }
}
