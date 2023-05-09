import 'package:flutter/material.dart';
import 'check_valid_position.dart';
import 'dominoes.dart';
import 'kingdoms.dart';
import 'show_domino_functions.dart';

// ignore: must_be_immutable
class PlayerPlacementGrid extends StatefulWidget {
  int i;
  int j;
  double height;
  double width;
  Domino? domino;
  Kingdom kingdom;
  Widget scoreTextWidget;
  PlayerPlacementGrid({
    required this.i,
    required this.j,
    required this.kingdom,
    required this.domino,
    required this.scoreTextWidget,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  State<PlayerPlacementGrid> createState() => _PlayerPlacementGridState();
}

class _PlayerPlacementGridState extends State<PlayerPlacementGrid> {
  @override
  Widget build(BuildContext context) {
    Kingdom kingdom = widget.kingdom;

    // if there's no domino, do nothing
    if (widget.domino == null) {
      // get the crowns and colors we need to display
      List temp = kingdom.kingdomDisplay(kingdom.kingdomCrowns, kingdom.kingdomColors);
      List<List<int>> crowns = temp[0];
      List<List<String>> colors = temp[1];
      // this is for determining how big the screen has to be:
      int numRows = crowns.length;
      int numColumns = crowns[0].length;
      // if no domino is selected, display the score as one part
      widget.scoreTextWidget = Text(
        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        'Score: ${widget.kingdom.score(widget.kingdom.kingdomCrowns, widget.kingdom.kingdomColors)}',
      );

      return PlayerKingdomGrid(
        numColumns: numColumns,
        numRows: numRows,
        crowns: crowns,
        colors: colors,
        scoreTextWidget: widget.scoreTextWidget,
        height: widget.height,
        width: widget.width,
      );
    }

    // otherwise, let's get this party started:
    // check to make sure the placement is valid
    String validPositionMessage;
    kingdom.placeDomino(widget.domino!, widget.i, widget.j);
    // show the results of the new placement
    List temp = kingdom.kingdomDisplay(kingdom.newKingdomCrowns, kingdom.newKingdomColors);
    List<List<int>> crowns = temp[0];
    List<List<String>> colors = temp[1];
    int numRows = crowns.length;
    int numColumns = crowns[0].length;
    // show the score as two parts this time
    widget.scoreTextWidget = Text(
      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      'Score: ${widget.kingdom.score(widget.kingdom.kingdomCrowns, widget.kingdom.kingdomColors)} + ${widget.kingdom.score(widget.kingdom.newKingdomCrowns, widget.kingdom.newKingdomColors) - widget.kingdom.score(widget.kingdom.kingdomCrowns, widget.kingdom.kingdomColors)}',
    );

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe west
        if (details.primaryVelocity! < 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino!, widget.i, widget.j + 1);
          if (validPositionMessage != '') {
          } else {
            // change the positioning accordingly
            setState(() {
              widget.j = widget.j + 1;
            });
          }
        }
        // Swipe east
        if (details.primaryVelocity! > 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino!, widget.i, widget.j - 1);
          if (validPositionMessage != '') {
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
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino!, widget.i + 1, widget.j);
          if (validPositionMessage != '') {
          } else {
            setState(() {
              widget.i = widget.i + 1;
            });
          }
        }
        // Swipe north
        if (details.primaryVelocity! < 0) {
          validPositionMessage = checkValidMovementAtPositionIJ(kingdom, widget.domino!, widget.i - 1, widget.j);
          if (validPositionMessage != '') {
          } else {
            setState(() {
              widget.i = widget.i - 1;
            });
          }
        }
      },
      onDoubleTap: () {
        if (widget.i == 8 && widget.domino!.horizontal) return;
        if (widget.j == 8 && !widget.domino!.horizontal) return;
        setState(() {
          widget.domino!.rotate();
        });
      },
      child: PlayerKingdomGrid(
        numColumns: numColumns,
        numRows: numRows,
        crowns: crowns,
        colors: colors,
        scoreTextWidget: widget.scoreTextWidget,
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}

// ignore: must_be_immutable
class PlayerKingdomGrid extends StatelessWidget {
  int numColumns;
  int numRows;
  double height;
  double width;
  List<List<int>> crowns;
  List<List<String>> colors;
  Widget scoreTextWidget;
  PlayerKingdomGrid({
    super.key,
    required this.numColumns,
    required this.numRows,
    required this.crowns,
    required this.colors,
    required this.scoreTextWidget,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Center(child: scoreTextWidget),
        ),
        Container(
          color: const Color.fromRGBO(245, 245, 245, 0.1),
          height: height / 2.1,
          child: Center(
            child: SizedBox(
              width: (width / 1.3) * (numColumns / 5) + numColumns * 4,
              height: (width / 1.3) * (numRows / 5) + numRows * 4,
              child: Column(children: getImages(numRows, numColumns, crowns, colors)),
            ),
          ),
        ),
      ],
    );
  }
}
