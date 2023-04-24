import 'package:flutter/material.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dominoes.dart';

class DominoSelectionInterface extends StatefulWidget {
  final List<Domino> dominoOptionsForSelection;
  final Domino? activePlayersSelectedDomino;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;
  const DominoSelectionInterface({
    super.key,
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
      dominoOptionsForSelection: const [],
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );
    DominoSelectionColumn dominoSelectionColumnTwo = DominoSelectionColumn(
      dominoOptionsForSelection: widget.dominoOptionsForSelection,
      activePlayersSelectedDomino: widget.activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: widget.onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: widget.onDominoChosenByActivePlayer,
      panelController: widget.panelController,
    );

    Color textButtonColor = (dominoSelectionColumnTwo.activePlayersSelectedDomino == null) ? Colors.white : Colors.blue;

    return Center(
      child: Container(
        height: 500,
        color: Colors.white24,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dominoSelectionColumnOne,
                dominoSelectionColumnTwo,
              ],
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Domino? activePlayersSelectedDomino = dominoSelectionColumnTwo.activePlayersSelectedDomino;
                if (activePlayersSelectedDomino == null) return;
                widget.onDominoChosenByActivePlayer(activePlayersSelectedDomino);

                // close the window
                widget.panelController.close();
              },
              child: Text(
                'Select',
                style: TextStyle(
                  color: textButtonColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DominoSelectionColumn extends StatefulWidget {
  final List<Domino> dominoOptionsForSelection;
  Domino? activePlayersSelectedDomino;
  final Function onDominoSelectedByActivePlayer;
  final Function onDominoChosenByActivePlayer;
  final PanelController panelController;

  // final Function onDominoPressed;
  // ignore: prefer_const_constructors_in_immutables
  DominoSelectionColumn({
    super.key,
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

      // if the card is taken, do nothing
      if (widget.dominoOptionsForSelection[index].taken) {
        return;
      }

      // select and use the tapped piece
      _selectedIndex = index;
      widget.activePlayersSelectedDomino = widget.dominoOptionsForSelection[_selectedIndex];
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
        return dominoOption.placed
            ? const SizedBox()
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _onCardTapped(index);
                    },
                    child: SizedBox(
                      width: 124,
                      child: dominoOption.taken ? const SizedBox(height: 60) : displayDomino(dominoOption),
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
