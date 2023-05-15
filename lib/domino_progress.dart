import 'package:kingdomino/player_placement_grid.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'colors.dart';
import 'kingdoms.dart';
import 'dominoes.dart';
import 'package:flutter/material.dart';

void showDominoProgress(BuildContext context, List<Domino> dominoesRemaining) {
  List<Domino> everyDomino = returnEveryDominoFunction();
  Map<List, int> originalDominoCount = {};
  Map<List, int> currentDominoCount = {};

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: const [SizedBox()],
        ),
      );
    },
  );
}

Widget showSection(List data, double size) {
  // data is in form [color, value]

  Text overlayText = Text(
    data[1],
    style: const TextStyle(
      fontSize: 45,
      color: Color.fromRGBO(245, 245, 245, 0.9),
    ),
  );

  Widget dominoSection = showDominoSection(data[0], size);

  return Stack(
    children: [dominoSection, overlayText],
  );
}
