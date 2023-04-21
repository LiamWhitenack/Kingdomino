import 'package:flutter/material.dart';
import 'package:kingdomino/player_placement_grid.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  Domino? activePlayersSelectedDomino;
  Kingdom kingdomOne = Kingdom();
  Widget scoreTextWidget = Text('data');
  int i = 5;
  int j = 4;
  List<Domino> dominoOptionsForSelection = drawNSortedDominoes(4, returnEveryDominoFunction());

  void onDominoSelectedByActivePlayer(Domino domino) {
    setState(() {
      activePlayersSelectedDomino = domino;
    });
  }

  @override
  Widget build(BuildContext context) {
    scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');

    return SlidingUpPanel(
      collapsed: Container(
        color: Colors.white,
        height: 75,
        child: const Center(
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
          ),
        ),
      ),
      slideDirection: SlideDirection.DOWN,
      minHeight: 75,
      maxHeight: MediaQuery.of(context).size.height,
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      panelBuilder: (ScrollController) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          DominoSelectionInterface(
            dominoOptionsForSelection: dominoOptionsForSelection,
            activePlayersSelectedDomino: activePlayersSelectedDomino,
            onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
          ),
          const SizedBox(
            height: 75,
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 250),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                PlayerPlacementGrid(
                  i: i,
                  j: j,
                  kingdom: kingdomOne,
                  domino: activePlayersSelectedDomino,
                  scoreTextWidget: scoreTextWidget,
                ),
                TextButton(
                  onPressed: () {
                    i = kingdomOne.i;
                    j = kingdomOne.j;
                    // make sure that the placement of the piece is legitimate, otherwise show message explaining what went wrong
                    String errorMessage =
                        checkValidPlacementAtPositionIJ(kingdomOne, activePlayersSelectedDomino!, i, j);
                    if (errorMessage != '') {
                      print(errorMessage);
                      return;
                    }

                    // mark the domino as taken so that it doesn't appear anymore
                    activePlayersSelectedDomino!.placed = true;

                    scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');
                    kingdomOne.updateBoard();
                    setState(() {});
                  },
                  child: const Text("Place"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
