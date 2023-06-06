import 'package:kingdomino/show_domino_functions.dart';
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

  // sort the colors
  allDominoData.sort(mySortComparison);

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
          currentDominoCount[dominoSectionData] = currentDominoCount[dominoSectionData]! + 1;
        }
      }
    }
  }

  // "close" button
  TextButton closeWindowButton = TextButton(
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
    child: const Text('close'),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [...showDominoCounts(originalDominoCount, currentDominoCount), closeWindowButton],
        ),
      );
    },
  );
}

int mySortComparison(DominoSectionData a, DominoSectionData b) {
  if (appearsBefore(a, b, ['yellow', 'swamp_green', 'baby_blue', 'pink', 'brown', 'purple'])) {
    return -1;
  } else {
    return 1;
  }
}

bool appearsBefore(DominoSectionData a, DominoSectionData b, List<String> father) {
  if (a.color == b.color) return (a.value < b.value);
  for (String color in father) {
    if (color == b.color) return false;
    if (color == a.color) return true;
  }
  return false;
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

Widget showSection(DominoSectionData data, double size) {
  // data is in form [color, value]

  Text overlayText = Text(
    data.value > 0 ? '${data.value}' : '',
    style: const TextStyle(
      fontSize: 45,
      color: Color.fromRGBO(245, 245, 245, 0.9),
    ),
  );

  Widget dominoSection = showDominoSection(data.color, size);

  return Stack(
    alignment: AlignmentDirectional.center,
    children: [dominoSection, overlayText],
  );
}

List<Widget> showDominoCounts(
  Map<DominoSectionData, int> originalDominoCount,
  Map<DominoSectionData, int> currentDominoCount,
) {
  List<Widget> dominoSections = [const SizedBox(height: 50)];
  for (DominoSectionData dominoSectionData in originalDominoCount.keys) {
    dominoSections.add(Center(
        child: SizedBox(
      width: 150,
      child: Row(
        children: [
          showSection(dominoSectionData, 60.0),
          const SizedBox(width: 20),
          Text(
            '${currentDominoCount[dominoSectionData]!} / ${originalDominoCount[dominoSectionData]!}',
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    )));
    dominoSections.add(const SizedBox(height: 80.0 / 2));
  }
  return [...dominoSections];
}
