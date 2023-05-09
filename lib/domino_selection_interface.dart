// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kingdomino/check_valid_position.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'domino_selection_column.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

// ignore:, must_be_immutable
class DominoSelectionInterface extends StatefulWidget {
  final List<Domino> dominoesInTheBox;
  List<Kingdom> kingdoms;
  Domino? activePlayersSelectedDomino;
  bool showTextButton;
  final int kingdomSelectingIndex;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final Function organizeKingdomsByColumnOrder;
  final Function updateKingdomsList;
  final Function updateShowTextButton;
  final PanelController panelController;
  final List<Domino> dominoOptionsForSelectionColumnOne;
  final List<Domino> dominoOptionsForSelectionColumnTwo;
  DominoSelectionInterface({
    super.key,
    required this.showTextButton,
    required this.kingdomSelectingIndex,
    required this.kingdoms,
    required this.dominoesInTheBox,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
    required this.onDominoChosenByActivePlayer,
    required this.organizeKingdomsByColumnOrder,
    required this.updateKingdomsList,
    required this.updateShowTextButton,
    required this.panelController,
    required this.dominoOptionsForSelectionColumnOne,
    required this.dominoOptionsForSelectionColumnTwo,
  });

  @override
  State<DominoSelectionInterface> createState() => _DominoSelectionInterfaceState();
}

class _DominoSelectionInterfaceState extends State<DominoSelectionInterface> {
  bool checkToSeeIfNeedsToBeRebuilt = true;
  void fillAnEmptyColumn(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    int numberOfDominoesToDraw = widget.kingdoms.length;
    if (widget.kingdoms.length == 2) numberOfDominoesToDraw = 4;
    bool allDominosPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnOne) {
      if (!domino.placed) allDominosPlaced = false;
    }
    if (allDominosPlaced) {
      List<Domino> dominoesToAdd = drawNSortedDominoes(numberOfDominoesToDraw, widget.dominoesInTheBox);
      // fill the column
      dominoOptionsForSelectionColumnOne.addAll(dominoesToAdd);
      return;
    }
    allDominosPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnTwo) {
      if (!domino.placed) allDominosPlaced = false;
    }
    if (allDominosPlaced) {
      List<Domino> dominoesToAdd = drawNSortedDominoes(numberOfDominoesToDraw, widget.dominoesInTheBox);
      // fill the column
      dominoOptionsForSelectionColumnTwo.addAll(dominoesToAdd);
      return;
    } else {
      print('there were no empty columns!');
    }
  }

  bool allDominosTakenOrPlaced(dominoOptionsForSelectionColumn) {
    for (Domino domino in dominoOptionsForSelectionColumn) {
      // if the domino hasn't been taken AND hasn't been placed
      if (!domino.taken && !domino.placed) {
        return false;
      }
    }
    return true;
  }

  bool allDominosTaken(dominoOptionsForSelectionColumn) {
    for (Domino domino in dominoOptionsForSelectionColumn) {
      // if the domino hasn't been taken AND hasn't been placed
      if (!domino.taken) {
        return false;
      }
    }
    return true;
  }

  bool allDominosPlaced(dominoOptionsForSelectionColumn) {
    for (Domino domino in dominoOptionsForSelectionColumn) {
      // if the domino hasn't been taken AND hasn't been placed
      if (!domino.placed) {
        return false;
      }
    }
    return true;
  }

  bool aColumnNeedsToBeRefilled(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    // a column only needs to be refilled when one row has all dominos selected
    // and the other has all dominos taken

    // check to see if column one needs to be replaced:
    if (allDominosTaken(dominoOptionsForSelectionColumnOne) && allDominosPlaced(dominoOptionsForSelectionColumnTwo)) {
      return true;
      // now column two:
    } else if (allDominosPlaced(dominoOptionsForSelectionColumnOne) &&
        allDominosTaken(dominoOptionsForSelectionColumnTwo)) {
      return true;
      // if neither, return false:
    } else {
      return false;
    }
  }

  bool kingdomsNeedToBeSorted(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    // the kingdoms need to be resorted when a column is filled in

    // check to see if column one needs to be replaced:
    if (allDominosTaken(dominoOptionsForSelectionColumnOne) && allDominosPlaced(dominoOptionsForSelectionColumnTwo)) {
      return true;
      // now column two:
    } else if (allDominosPlaced(dominoOptionsForSelectionColumnOne) &&
        allDominosTaken(dominoOptionsForSelectionColumnTwo)) {
      return true;
      // if neither, return false:
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Domino> dominoOptionsForSelectionColumnOne = widget.dominoOptionsForSelectionColumnOne;
    List<Domino> dominoOptionsForSelectionColumnTwo = widget.dominoOptionsForSelectionColumnTwo;

    // reorganize the list of kingdoms
    if (aColumnNeedsToBeRefilled(dominoOptionsForSelectionColumnOne, widget.dominoOptionsForSelectionColumnTwo)) {
      fillAnEmptyColumn(
        dominoOptionsForSelectionColumnOne,
        widget.dominoOptionsForSelectionColumnTwo,
      );
      widget.kingdoms = widget.organizeKingdomsByColumnOrder(
        dominoOptionsForSelectionColumnOne,
        dominoOptionsForSelectionColumnTwo,
      );
      widget.updateKingdomsList(widget.kingdoms);
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

    TextButton selectDominoTextButton = TextButton(
      onPressed: () {
        Domino? activePlayersSelectedDomino = widget.activePlayersSelectedDomino;

        activePlayersSelectedDomino!.taken = true;
        widget.kingdoms[widget.kingdomSelectingIndex] =
            widget.onDominoChosenByActivePlayer(activePlayersSelectedDomino);

        // force the player to place their domino if they have a domino ready to place
        if (widget.kingdoms[widget.kingdomSelectingIndex].domino != null) {
          // if there is a space to put the domino, close the selection interface
          if ((findTheFirstAvailableSpot(
                  widget.kingdoms[widget.kingdomSelectingIndex], widget.kingdoms[widget.kingdomSelectingIndex].domino!))
              .isNotEmpty) {
            widget.panelController.hide();
          }
        }

        // set the activePlayersSelectedDomino value to null since the kingdom will later need to select a new value
        activePlayersSelectedDomino = null;

        widget.updateShowTextButton(false);
        setState(() {});
      },
      child: const Text(
        'Select',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20,
        ),
      ),
    );

    return Container(
      height: 700,
      color: Colors.white,
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
          widget.showTextButton ? selectDominoTextButton : const SizedBox(),
        ],
      ),
    );
  }
}
