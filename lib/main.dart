import 'package:flutter/material.dart';
import 'package:kingdomino/check_valid_position.dart';
import 'package:kingdomino/player_interaction_interface.dart';
import 'domino_selection_interface.dart';
import 'player_placement_grid.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

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
        body: Container(color: const Color.fromRGBO(149, 107, 169, 0.5), child: const PlayerInteractionInterface()),
      ),
    );
  }
}
