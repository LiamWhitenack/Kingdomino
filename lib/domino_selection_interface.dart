import 'package:flutter/material.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class DominoSelectionInterface extends StatefulWidget {
  final List<Domino> dominoOptionsForSelection;
  final Domino? activePlayersSelectedDomino;
  final Kingdom kingdomSelecting;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;
  const DominoSelectionInterface({
    super.key,
    required this.kingdomSelecting,
    required this.dominoOptionsForSelection,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
    required this.onDominoChosenByActivePlayer,
    required this.panelController,
  });

  @override
  State<DominoSelectionInterface> createState() => _DominoSelectionInterfaceState();
}

class _DominoSelectionInterfaceState extends State<DominoSelectionInterface> {
  @override
  Widget build(BuildContext context) {
    DominoSelectionColumn dominoSelectionColumnOne = DominoSelectionColumn(
      dominoOptionsForSelection: [],
      kingdomSelecting: widget.kingdomSelecting,
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );
    DominoSelectionColumn dominoSelectionColumnTwo = DominoSelectionColumn(
      dominoOptionsForSelection: widget.dominoOptionsForSelection,
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

                    // close the window
                    widget.panelController.close();
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
