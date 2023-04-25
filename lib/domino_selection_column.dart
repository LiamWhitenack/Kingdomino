import 'package:flutter/material.dart';
import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/kingdoms.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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