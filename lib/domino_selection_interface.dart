// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kingdomino/check_valid_position.dart';
import 'package:kingdomino/kingdom_progress.dart';
import 'package:kingdomino/player_placement_grid.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'domino_selection_column.dart';
import 'dominoes.dart';
import 'icons.dart';
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

  void selectPieceAction() {
    Domino? activePlayersSelectedDomino = widget.activePlayersSelectedDomino;

    activePlayersSelectedDomino!.taken = true;
    widget.kingdoms[widget.kingdomSelectingIndex] = widget.onDominoChosenByActivePlayer(activePlayersSelectedDomino);

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

    FloatingActionButton selectDominoTextButton = FloatingActionButton(
      backgroundColor: Colors.grey,
      onPressed: () {
        selectPieceAction();
        setState(() {});
      },
      child: const Text(
        '+',
        style: TextStyle(color: Colors.white, fontSize: 32),
      ),
    );

    Widget showKingdomProgressButton = SizedBox(
      width: 77,
      height: 77,
      child: IconButton(
        onPressed: () {
          showKingdomProgress(context, widget.kingdoms);
        },
        icon: grey2x2Grid(30),
      ),
    );

    Widget showDominoes = SizedBox(
      width: 77,
      child: IconButton(
        onPressed: () {},
        icon: grey2x1Grid(30),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height / 1.0,
      color: Colors.white,
      margin: const EdgeInsets.all(12.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 7.83),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dominoSelectionColumnOne,
                  // add a gap if there's two columns
                  (dominoSelectionColumnOne.dominoOptionsForSelection.isNotEmpty &&
                          dominoSelectionColumnTwo.dominoOptionsForSelection.isNotEmpty)
                      ? SizedBox(width: MediaQuery.of(context).size.width / 39)
                      : const SizedBox(width: 0),
                  dominoSelectionColumnTwo,
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
            ],
          ),
          SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showKingdomProgressButton,
                  SizedBox(
                    width: 300 - (77 * 2),
                    child: widget.showTextButton
                        ? selectDominoTextButton
                        : const SizedBox(
                            width: 200 - (57 * 2),
                          ),
                  ),
                  showDominoes
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
