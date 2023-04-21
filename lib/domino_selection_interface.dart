import 'package:flutter/material.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'dominoes.dart';

class DominoSelectionInterface extends StatelessWidget {
  final List<Domino> dominoOptionsForSelection;
  final Domino? activePlayersSelectedDomino;
  final Function onDominoSelectedByActivePlayer;
  const DominoSelectionInterface({
    super.key,
    required this.dominoOptionsForSelection,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DominoSelectionColumn(
          dominoOptionsForSelection: dominoOptionsForSelection,
          activePlayersSelectedDomino: activePlayersSelectedDomino,
          onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
        ),
        const SizedBox(width: 50),
        DominoSelectionColumn(
          dominoOptionsForSelection: dominoOptionsForSelection,
          activePlayersSelectedDomino: activePlayersSelectedDomino,
          onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
        ),
      ],
    );
  }
}

class DominoSelectionColumn extends StatefulWidget {
  final List<Domino> dominoOptionsForSelection;
  Domino? activePlayersSelectedDomino;
  final Function onDominoSelectedByActivePlayer;

  // final Function onDominoPressed;
  // ignore: prefer_const_constructors_in_immutables
  DominoSelectionColumn({
    super.key,
    required this.dominoOptionsForSelection,
    required this.activePlayersSelectedDomino,
    required this.onDominoSelectedByActivePlayer,
  });

  @override

  // ignore: library_private_types_in_public_api
  _DominoSelectionWidgetState createState() => _DominoSelectionWidgetState();
}

class _DominoSelectionWidgetState extends State<DominoSelectionColumn> {
  int _selectedIndex = -1;

  void _onCardTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onDominoSelectedByActivePlayer(widget.dominoOptionsForSelection[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.dominoOptionsForSelection.asMap().entries.map((entry) {
        final int index = entry.key;
        final Domino dominoOption = entry.value;
        return GestureDetector(
          onTap: () {
            _onCardTapped(index);
          },
          child: SizedBox(
            width: 118,
            child: Card(
              color: _selectedIndex == index ? const Color.fromRGBO(149, 107, 169, 0.5) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: displayDomino(dominoOption),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
