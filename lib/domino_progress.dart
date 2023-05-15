import 'package:kingdomino/player_placement_grid.dart';
import 'package:kingdomino/show_domino_functions.dart';
import 'colors.dart';
import 'kingdoms.dart';
import 'dominoes.dart';
import 'package:flutter/material.dart';

void showDominoProgress(BuildContext context, List<Domino> dominoesRemaining) {
  List<Domino> everyDomino = returnEveryDominoFunction();
  Map<DominoSectionData, int> originalDominoCount = {};
  Map<DominoSectionData, int> currentDominoCount = {};

  List<DominoSectionData> allDominoData = [];

  bool brokenLoop;

  // get all domino section types
  for (Domino domino in everyDomino) {
    for (int i = 0; i < 2; i++) {
      brokenLoop = false;
      for (DominoSectionData dominoSectionData in allDominoData) {
        if (dominoSectionData.hasSameData(domino.colors[i], domino.crowns[i])) {
          brokenLoop = true;
          break;
        }
      }
      if (!brokenLoop) {
        allDominoData.add(DominoSectionData(domino.colors[i], domino.crowns[i]));
      }
    }
  }

  // initialize domino counts
  for (DominoSectionData dominoSectionData in allDominoData) {
    originalDominoCount[dominoSectionData] = 0;
    currentDominoCount[dominoSectionData] = 0;
  }

  // count up totals for original dominoes
  for (Domino domino in everyDomino) {
    for (int i = 0; i < 2; i++) {
      for (DominoSectionData dominoSectionData in allDominoData) {
        if (dominoSectionData.hasSameData(domino.colors[i], domino.crowns[i])) {
          originalDominoCount[dominoSectionData] = originalDominoCount[dominoSectionData]! + 1;
        }
      }
    }
  }

  // count up totals for current dominoes
  for (Domino domino in dominoesRemaining) {
    for (int i = 0; i < 2; i++) {
      for (DominoSectionData dominoSectionData in allDominoData) {
        if (dominoSectionData.hasSameData(domino.colors[i], domino.crowns[i])) {
          originalDominoCount[dominoSectionData] = originalDominoCount[dominoSectionData]! + 1;
        }
      }
    }
  }

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

class DominoSectionData {
  int value;
  String color;

  DominoSectionData(this.color, this.value);
  bool hasSameData(String newColor, int newValue) {
    return (color == newColor && value == newValue);
  }
}

bool checkIfListContainsList(List container, List element) {
  for (List containerElement in container) {
    if (containerElement[0] == element[0] && (containerElement[1] == element[1])) {
      return true;
    }
  }
  return false;
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
