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
      // rotate the old selected domino to its original orientation
      if (_selectedIndex >= 0) {
        widget.dominoOptionsForSelection[_selectedIndex].revertToOriginalOrientation();
      }

      // if the card is noColorIfDominoNotTakenElseColor, do nothing
      if (widget.dominoOptionsForSelection[index].noColorIfDominoNotTakenElseColor != 'noColor') {
        return;
      }

      for (Domino domino in widget.dominoOptionsForSelection) {
        if (!domino.taken) {
          domino.noColorIfDominoNotTakenElseColor = 'noColor';
        }
      }

      // select and use the tapped domino
      _selectedIndex = index;
      widget.activePlayersSelectedDomino = widget.dominoOptionsForSelection[_selectedIndex];
      // change the color of the backdrop to the color of the kingdom
      widget.activePlayersSelectedDomino?.noColorIfDominoNotTakenElseColor = widget.kingdomSelecting.color;
      widget.onDominoSelectedByActivePlayer(widget.activePlayersSelectedDomino);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if there aren't any dominoes, no need to do anything :)
    if (widget.dominoOptionsForSelection.isEmpty) return const SizedBox();
    return Column(
      children: widget.dominoOptionsForSelection.asMap().entries.map(
        (entry) {
          final int index = entry.key;
          final Domino dominoOption = entry.value;
          Widget dominoDisplay = dominoOption.placed
              ? SizedBox(height: (MediaQuery.of(context).size.height / 13))
              : displayDominoInABox(dominoOption, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width,
                  colorOfTheBox: dominoOption.noColorIfDominoNotTakenElseColor);

          return dominoOption.placed
              ? const SizedBox()
              : Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onCardTapped(index);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.45,
                        child: dominoDisplay,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 31,
                    ),
                  ],
                );
        },
      ).toList(),
    );
  }
}
