import 'package:flutter/material.dart';
import 'package:kingdomino/check_valid_position.dart';
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
    List<Domino> dominoesInTheBox = returnEveryDominoFunction();
    Kingdom kingdomOne = Kingdom();
    int i = 5;
    int j = 4;
    return MaterialApp(
      title: 'Kingdomino',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kingdomino'),
          backgroundColor: const Color.fromRGBO(149, 107, 169, 1),
        ),
        body: Container(
          color: const Color.fromRGBO(149, 107, 169, 0.5),
          child: Column(
            children: [
              DominoSelectionInterface(dominoOptionsForSelection: drawNSortedDominoes(4, dominoesInTheBox)),
              PlayerPlacementGrid(i: i, j: j, kingdom: kingdomOne, domino: dominoesInTheBox[42]),
              TextButton(
                  onPressed: () {
                    i = kingdomOne.i;
                    j = kingdomOne.j;
                    // make sure that the placement of the piece is legitimate, otherwise show message explaining what went wrong
                    String errorMessage = checkValidPlacementAtPositionIJ(kingdomOne, dominoesInTheBox[42], i, j);
                    if (errorMessage != '') {
                      print(errorMessage);
                      return;
                    }

                    kingdomOne.updateBoard();
                    print(kingdomOne.score());
                  },
                  child: const Text("Place"))
            ],
          ),
        ),
      ),
    );
  }
}
