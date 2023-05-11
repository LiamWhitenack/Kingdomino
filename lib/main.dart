import 'package:flutter/material.dart';
import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/kingdoms.dart';
import 'package:kingdomino/player_interaction_interface.dart';

void main() {
  runApp(const HomeScreen());
}

// this is where you should be able to set up a game with custom settings
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlayGame();
  }
}

class PlayGame extends StatelessWidget {
  const PlayGame({super.key});

  List<Kingdom> generateListOfNKingdoms(int n) {
    List<String> colors = ['navy', 'forest', 'maroon', 'gold'];
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
    int numberOfKingdoms = 4;
    int numberOfRounds = 13;
    List<Kingdom> kingdoms = generateListOfNKingdoms(numberOfKingdoms);
    if (numberOfKingdoms == 2) numberOfRounds = 7;
    return MaterialApp(
      title: 'Kingdomino',
      home: Scaffold(
        // ignore: avoid_unnecessary_containers
        body: PlayGameScreen(
          kingdoms: kingdoms,
          numberOfKingdoms: numberOfKingdoms,
          numberOfRounds: numberOfRounds,
        ),
      ),
    );
  }
}

// I don't think this has to be the way I did it, but I needed to make this
// class to get the screen height now that a MaterialApp has already been made
class PlayGameScreen extends StatelessWidget {
  final int numberOfRounds;

  final List<Kingdom> kingdoms;

  final int numberOfKingdoms;

  const PlayGameScreen(
      {super.key, required this.numberOfRounds, required this.kingdoms, required this.numberOfKingdoms});

  @override
  Widget build(BuildContext context) {
    return PlayerInteractionInterface(
      dominoesInTheBox: returnEveryDominoFunction(),
      numberOfRounds: numberOfRounds,
      kingdoms: kingdoms,
      numberOfUniqueKingdoms: numberOfKingdoms,
      interfaceHeight: MediaQuery.of(context).size.height,
      interfaceWidth: MediaQuery.of(context).size.width,
    );
  }
}
