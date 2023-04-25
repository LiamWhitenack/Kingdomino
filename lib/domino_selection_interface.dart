// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'domino_selection_column.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class DominoSelectionInterface extends StatefulWidget {
  final List<Domino> dominoesInTheBox;
  final List<Kingdom> kingdoms;
  final Domino? activePlayersSelectedDomino;
  final int kingdomSelectingIndex;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;
  final List<Domino> dominoOptionsForSelectionColumnOne;
  final List<Domino> dominoOptionsForSelectionColumnTwo;
  const DominoSelectionInterface({
    super.key,
    required this.kingdomSelectingIndex,
    required this.kingdoms,
    required this.dominoesInTheBox,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
    required this.onDominoChosenByActivePlayer,
    required this.panelController,
    required this.dominoOptionsForSelectionColumnOne,
    required this.dominoOptionsForSelectionColumnTwo,
  });

  @override
  State<DominoSelectionInterface> createState() => _DominoSelectionInterfaceState();
}

class _DominoSelectionInterfaceState extends State<DominoSelectionInterface> {
  void fillAnEmptyColumn(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    bool allPiecesPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnOne) {
      if (!domino.placed) allPiecesPlaced = false;
    }
    if (allPiecesPlaced) {
      List<Domino> dominoesToAdd = drawNSortedDominoes(4, widget.dominoesInTheBox);
      // fill the column
      dominoOptionsForSelectionColumnOne.addAll(dominoesToAdd);
      return;
    }
    allPiecesPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnTwo) {
      if (!domino.placed) allPiecesPlaced = false;
    }
    if (allPiecesPlaced) {
      List<Domino> dominoesToAdd = drawNSortedDominoes(4, widget.dominoesInTheBox);
      // fill the column
      dominoOptionsForSelectionColumnTwo.addAll(dominoesToAdd);
      return;
    } else {
      print('there were no empty columns!');
    }
  }

  bool noRemainingOptionsForSelction(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    // assume the condition is true first
    bool allPiecesTakenOrPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnOne) {
      // if the piece hasn't been taken AND hasn't been placed
      if (!domino.taken && !domino.placed) allPiecesTakenOrPlaced = false;
    }
    for (Domino domino in dominoOptionsForSelectionColumnTwo) {
      // if the piece hasn't been taken AND hasn't been placed
      if (!domino.taken && !domino.placed) allPiecesTakenOrPlaced = false;
    }
    return allPiecesTakenOrPlaced;
  }

  @override
  Widget build(BuildContext context) {
    List<Domino> dominoOptionsForSelectionColumnOne = widget.dominoOptionsForSelectionColumnOne;
    List<Domino> dominoOptionsForSelectionColumnTwo = widget.dominoOptionsForSelectionColumnTwo;

    if (noRemainingOptionsForSelction(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo)) {
      // reorganize the list of kingdoms
      fillAnEmptyColumn(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
    }

    DominoSelectionColumn dominoSelectionColumnOne = DominoSelectionColumn(
      dominoOptionsForSelection: dominoOptionsForSelectionColumnOne,
      kingdomSelecting: widget.kingdoms[widget.kingdomSelectingIndex],
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );
    DominoSelectionColumn dominoSelectionColumnTwo = DominoSelectionColumn(
      dominoOptionsForSelection: dominoOptionsForSelectionColumnTwo,
      kingdomSelecting: widget.kingdoms[widget.kingdomSelectingIndex],
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );

    TextButton selectPieceTextButton = TextButton(
      onPressed: () {
        Domino? activePlayersSelectedDomino = dominoSelectionColumnTwo.activePlayersSelectedDomino;

        if (activePlayersSelectedDomino == null) return;
        activePlayersSelectedDomino.taken = true;
        widget.onDominoChosenByActivePlayer(activePlayersSelectedDomino);

        // force the player to place their piece if they have a piece ready to place
        if (widget.kingdoms[widget.kingdomSelectingIndex].domino != null) {
          widget.panelController.hide();
        }

        // set the activePlayersSelectedDomino value to null since the kingdom will later need to select a new value
        activePlayersSelectedDomino = null;

        // check to see if all of the pieces in the current column have been taken
        if (noRemainingOptionsForSelction(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo)) {
          fillAnEmptyColumn(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
        }
      },
      child: const Text(
        'Select',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20,
        ),
      ),
    );

    bool showTextButton = (dominoSelectionColumnTwo.activePlayersSelectedDomino == null) ? false : true;

    return Container(
      height: 700,
      color: Colors.white24,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dominoSelectionColumnOne,
              // add a gap if there's two columns
              (dominoSelectionColumnOne.dominoOptionsForSelection.isNotEmpty &&
                      dominoSelectionColumnTwo.dominoOptionsForSelection.isNotEmpty)
                  ? const SizedBox(width: 10)
                  : const SizedBox(width: 0),
              dominoSelectionColumnTwo,
            ],
          ),
          const SizedBox(height: 50),
          showTextButton ? selectPieceTextButton : const SizedBox(),
        ],
      ),
    );
  }
}
