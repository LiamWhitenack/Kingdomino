import 'package:flutter/material.dart';
import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/input_player_names.dart';
import 'package:kingdomino/kingdoms.dart';
import 'package:kingdomino/player_interaction_interface.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double numberOfPlayers = 3;

  List<String> returnImportantNames(List<TextEditingController> controllers, int n) {
    List<String> names = [];
    for (int i = 0; i < n; i++) {
      names.add(controllers[i].text);
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController maroonController = TextEditingController(text: 'Ralph');
    final TextEditingController forestController = TextEditingController(text: 'Jack');
    final TextEditingController navyController = TextEditingController(text: 'Piggy');
    final TextEditingController yellowController = TextEditingController(text: 'Simon');
    final List<TextEditingController> controllers = [
      maroonController,
      forestController,
      navyController,
      yellowController
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kingdomino'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                const Center(
                    child: Text(
                  'Number Of Players:',
                  style: TextStyle(fontSize: 16),
                )),

                Center(
                  child: SizedBox(
                    width: 200,
                    child: Slider(
                      value: numberOfPlayers,
                      min: 2,
                      max: 4,
                      divisions: 2,
                      label: numberOfPlayers.round().toString(),
                      onChanged: (newValue) => {setState(() => numberOfPlayers = newValue)},
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                InputPlayerNamesWidget(
                  numberOfPlayers: numberOfPlayers.round(),
                  maroonController: maroonController,
                  forestController: forestController,
                  navyController: navyController,
                  yellowController: yellowController,
                ),

                // button
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              playerNames: returnImportantNames(controllers, numberOfPlayers.round()),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'PLAY',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// this is where you should be able to set up a game with custom settings
class GameScreen extends StatelessWidget {
  final List<String> playerNames;
  const GameScreen({required this.playerNames, super.key});

  List<Kingdom> generateListOfNKingdoms(List<String> playerNames) {
    List<String> colors = ['maroon', 'forest', 'navy', 'yellow'];
    List<Kingdom> kingdoms = [];
    for (int i = 0; i < playerNames.length; i++) {
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
    List<Kingdom> kingdoms = generateListOfNKingdoms(playerNames);
    if (numberOfKingdoms == 2) numberOfRounds = 7;
    return MaterialApp(
      title: 'Kingdomino',
      home: Scaffold(
        // ignore: avoid_unnecessary_containers
        body: PlayerInteractionInterface(
          dominoesInTheBox: returnEveryDominoFunction(),
          numberOfRounds: numberOfRounds,
          kingdoms: kingdoms,
          numberOfUniqueKingdoms: numberOfKingdoms,
          interfaceHeight: MediaQuery.of(context).size.height,
          interfaceWidth: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

// // I don't think this has to be the way I did it, but I needed to make this
// // class to get the screen height now that a MaterialApp has already been made
// class PlayGameScreen extends StatelessWidget {
//   final int numberOfRounds;

//   final List<Kingdom> kingdoms;

//   final int numberOfKingdoms;

//   const PlayGameScreen(
//       {super.key, required this.numberOfRounds, required this.kingdoms, required this.numberOfKingdoms});

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
