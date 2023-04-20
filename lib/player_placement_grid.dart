import 'package:flutter/material.dart';
import 'check_valid_position.dart';
import 'dominoes.dart';
import 'kingdoms.dart';
import 'show_domino_functions.dart';

// ignore: must_be_immutable
class PlayerPlacementGrid extends StatefulWidget {
  int i;
  int j;
  Domino domino;
  Kingdom kingdom;
  PlayerPlacementGrid({required this.i, required this.j, required this.kingdom, required this.domino, super.key});

  @override
  State<PlayerPlacementGrid> createState() => _PlayerPlacementGridState();
}

class _PlayerPlacementGridState extends State<PlayerPlacementGrid> {
  @override
  Widget build(BuildContext context) {
    Kingdom kingdom = widget.kingdom;
    String validPositionMessage;
    kingdom.placePiece(widget.domino, widget.i, widget.j);
    // player1.updateBoard();
    List temp = kingdom.kingdomDisplay();
    List<List<int>> crowns = temp[0];
    List<List<String>> colors = temp[1];

    int numRows = crowns.length;
    int numColumns = crowns[0].length;
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe west
        if (details.primaryVelocity! < 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino, widget.i, widget.j + 1);
          if (validPositionMessage != '') {
            print(validPositionMessage);
          } else {
            setState(() {
              widget.j = widget.j + 1;
            });
          }
        }
        // Swipe east
        if (details.primaryVelocity! > 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino, widget.i, widget.j - 1);
          if (validPositionMessage != '') {
            print(validPositionMessage);
          } else {
            setState(() {
              widget.j = widget.j - 1;
            });
          }
        }
      },
      onVerticalDragEnd: (details) {
        // Swipe south
        if (details.primaryVelocity! > 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino, widget.i + 1, widget.j);
          if (validPositionMessage != '') {
            print(validPositionMessage);
          } else {
            setState(() {
              widget.i = widget.i + 1;
            });
          }
        }
        // Swipe north
        if (details.primaryVelocity! < 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino, widget.i - 1, widget.j);
          if (validPositionMessage != '') {
            print(validPositionMessage);
          } else {
            setState(() {
              widget.i = widget.i - 1;
            });
          }
        }
      },
      onDoubleTap: () {
        setState(() {
          widget.domino.rotate();
        });
      },
      child: Container(
        color: const Color.fromRGBO(245, 245, 245, 0),
        height: 350,
        child: Center(
          child: SizedBox(
            width: 300 * (numColumns / 5) + numColumns * 4,
            height: 300 * (numRows / 5) + numRows * 4,
            child: Column(
              children: getImages(numRows, numColumns, crowns, colors),
            ),
          ),
        ),
      ),
    );
  }
}
