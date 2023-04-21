import 'package:flutter/material.dart';
import 'package:kingdomino/player_placement_grid.dart';

import 'check_valid_position.dart';
import 'domino_selection_interface.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class PlayerInteractionInterface extends StatefulWidget {
  const PlayerInteractionInterface({super.key});

  @override
  State<PlayerInteractionInterface> createState() => _PlayerInteractionInterfaceState();
}

class _PlayerInteractionInterfaceState extends State<PlayerInteractionInterface> {
  @override
  List<Domino> dominoesInTheBox = returnEveryDominoFunction();
  Kingdom kingdomOne = Kingdom();
  Widget scoreTextWidget = Text('data');
  int i = 5;
  int j = 4;
  List<Domino> dominoOptionsForSelection = drawNSortedDominoes(4, returnEveryDominoFunction());
  Widget build(BuildContext context) {
    scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');

    return Column(
      children: [
        DominoSelectionInterface(dominoOptionsForSelection: dominoOptionsForSelection),
        PlayerPlacementGrid(
          i: i,
          j: j,
          kingdom: kingdomOne,
          domino: dominoesInTheBox[42],
          scoreTextWidget: scoreTextWidget,
        ),
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
              scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');
              kingdomOne.updateBoard();
              setState(() {});
            },
            child: const Text("Place"))
      ],
    );
  }
}
