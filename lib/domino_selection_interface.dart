import 'package:flutter/material.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class DominoSelectionInterface extends StatefulWidget {
  final List<Domino> dominoesInTheBox;
  final Domino? activePlayersSelectedDomino;
  final Kingdom kingdomSelecting;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;
  final List<Domino> dominoOptionsForSelectionColumnOne;
  final List<Domino> dominoOptionsForSelectionColumnTwo;
  const DominoSelectionInterface({
    super.key,
    required this.kingdomSelecting,
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
    bool allPiecesTakenOrPlaced = true;
    for (Domino domino in dominoOptionsForSelectionColumnOne) {
      if (!domino.taken | !domino.placed) allPiecesTakenOrPlaced = false;
    }
    for (Domino domino in dominoOptionsForSelectionColumnTwo) {
      if (!domino.taken | !domino.placed) allPiecesTakenOrPlaced = false;
    }
    return allPiecesTakenOrPlaced;
  }

  @override
  Widget build(BuildContext context) {
    List<Domino> dominoOptionsForSelectionColumnOne = widget.dominoOptionsForSelectionColumnOne;
    List<Domino> dominoOptionsForSelectionColumnTwo = widget.dominoOptionsForSelectionColumnTwo;

    if (noRemainingOptionsForSelction(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo)) {
      fillAnEmptyColumn(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
    }

    DominoSelectionColumn dominoSelectionColumnOne = DominoSelectionColumn(
      dominoOptionsForSelection: dominoOptionsForSelectionColumnOne,
      kingdomSelecting: widget.kingdomSelecting,
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );
    DominoSelectionColumn dominoSelectionColumnTwo = DominoSelectionColumn(
      dominoOptionsForSelection: dominoOptionsForSelectionColumnTwo,
      kingdomSelecting: widget.kingdomSelecting,
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
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
                  ? const SizedBox(width: 25)
                  : const SizedBox(width: 0),
              dominoSelectionColumnTwo,
            ],
          ),
          const SizedBox(height: 50),
          showTextButton
              ? TextButton(
                  onPressed: () {
                    Domino? activePlayersSelectedDomino = dominoSelectionColumnTwo.activePlayersSelectedDomino;

                    if (activePlayersSelectedDomino == null) return;
                    activePlayersSelectedDomino.taken = true;
                    widget.onDominoChosenByActivePlayer(activePlayersSelectedDomino);

                    // force the player to place their piece if they have a piece ready to place
                    if (widget.kingdomSelecting.domino != null) {
                      widget.panelController.hide();
                    }

                    // set the activePlayersSelectedDomino value to null since the kingdom will later need to select a new value
                    activePlayersSelectedDomino = null;

                    // check to see if all of the pieces in the current column have been taken
                    if (noRemainingOptionsForSelction(
                        dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo)) {
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
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DominoSelectionColumn extends StatefulWidget {
  final List<Domino> dominoOptionsForSelection;
  Domino? activePlayersSelectedDomino;
  final Kingdom kingdomSelecting;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;

  // final Function onDominoPressed;
  // ignore: prefer_const_constructors_in_immutables
  DominoSelectionColumn({
    super.key,
    required this.kingdomSelecting,
    required this.dominoOptionsForSelection,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
    required this.onDominoChosenByActivePlayer,
    required this.panelController,
  });

  @override

  // ignore: library_private_types_in_public_api
  _DominoSelectionColumnState createState() => _DominoSelectionColumnState();
}

class _DominoSelectionColumnState extends State<DominoSelectionColumn> {
  int _selectedIndex = -1;

  void _onCardTapped(int index) {
    setState(() {
      // rotate the old selected piece to its original orientation
      if (_selectedIndex >= 0) {
        widget.dominoOptionsForSelection[_selectedIndex].revertToOriginalOrientation();
      }

      // if the card is whiteIfPieceNotTakenElseColor, do nothing
      if (widget.dominoOptionsForSelection[index].whiteIfPieceNotTakenElseColor != 'white') {
        return;
      }

      for (Domino domino in widget.dominoOptionsForSelection) {
        if (!domino.taken) {
          domino.whiteIfPieceNotTakenElseColor = 'white';
        }
      }

      // select and use the tapped piece
      _selectedIndex = index;
      widget.activePlayersSelectedDomino = widget.dominoOptionsForSelection[_selectedIndex];
      // change the color of the backdrop to the color of the kingdom
      widget.activePlayersSelectedDomino?.whiteIfPieceNotTakenElseColor = widget.kingdomSelecting.color;
      widget.onDominoSelectedByActivePlayer(widget.activePlayersSelectedDomino);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if there aren't any dominoes, no need to do anything :)
    if (widget.dominoOptionsForSelection.isEmpty) return const SizedBox();
    return Column(
      children: widget.dominoOptionsForSelection.asMap().entries.map((entry) {
        final int index = entry.key;
        final Domino dominoOption = entry.value;
        Widget dominoDisplay = dominoOption.placed
            ? const SizedBox(height: 60)
            : displayDominoInABox(dominoOption, colorOfTheBox: dominoOption.whiteIfPieceNotTakenElseColor);

        return dominoOption.placed
            ? const SizedBox()
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _onCardTapped(index);
                    },
                    child: SizedBox(
                      width: 160,
                      child: dominoDisplay,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              );
      }).toList(),
    );
  }
}
