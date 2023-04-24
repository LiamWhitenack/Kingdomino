import 'dart:core';
import 'check_valid_position.dart';
import 'dominoes.dart';
import 'dart:math';

class Kingdom {
  late List<List<int>> kingdomCrowns;
  late List<List<String>> kingdomColors;
  late List<List<int>> newKingdomCrowns;
  late List<List<String>> newKingdomColors;
  late Domino domino;
  Domino? dominoInPurgatory;
  late bool fullyUpdated;
  late int i;
  late int j;
  final String color;

  Kingdom(this.color) {
    kingdomCrowns = List.generate(9, (_) => List.filled(9, -1));
    kingdomColors = List.generate(9, (_) => List.filled(9, 'white'));
    kingdomCrowns[4][4] = 0;
    kingdomColors[4][4] = 'grey';
    fullyUpdated = true;
    color;
  }

  List<List<String>> deepCopyColors(List<List<String>> source) {
    return source.map((e) => e.toList()).toList();
  }

  List<List<int>> deepCopyCrowns(List<List<int>> source) {
    return source.map((e) => e.toList()).toList();
  }

  void placePiece(Domino domino, int i, int j) {
    fullyUpdated = false;
    this.i = i;
    this.j = j;
    this.domino = domino;
    newKingdomCrowns = deepCopyCrowns(kingdomCrowns);
    newKingdomColors = deepCopyColors(kingdomColors);

    // place the domino horizontally or horizontally
    if (!domino.horizontal) {
      newKingdomCrowns[i][j] = domino.crowns[0];
      newKingdomCrowns[i + 1][j] = domino.crowns[1];
      newKingdomColors[i][j] = domino.colors[0];
      newKingdomColors[i + 1][j] = domino.colors[1];
    } else {
      newKingdomCrowns[i][j] = domino.crowns[0];
      newKingdomCrowns[i][j + 1] = domino.crowns[1];
      newKingdomColors[i][j] = domino.colors[0];
      newKingdomColors[i][j + 1] = domino.colors[1];
    }
  }

  void updateBoard() {
    checkValidPlacementAtPositionIJ(this, domino, i, j);
    kingdomCrowns = newKingdomCrowns;
    kingdomColors = newKingdomColors;
    fullyUpdated = false;
  }

  List<List<int>> getImportantRowsAndColumns(List<List<String>> kingdomColors) {
    List<int> rows = [];
    List<int> columns = [];

    // Check each row for partial completion
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (kingdomColors[i][j] != 'white') {
          rows.add(i);
          columns.add(j);
        }
      }
    }
    rows = rows.toSet().toList();
    columns = columns.toSet().toList();
    return [rows, columns];
  }

  List kingdomDisplay(List<List<int>> kingdomCrowns, List<List<String>> kingdomColors) {
    List<List<int>> displayKingdomCrowns = [];
    List<List<String>> displayKingdomColors = [];
    List<List<int>> importantRowsAndColumns = getImportantRowsAndColumns(kingdomColors);
    List<int> importantRows = importantRowsAndColumns[0];
    List<int> importantColumns = importantRowsAndColumns[1];

    // add the columns we want to see to a new list
    for (int i = importantRows.reduce(min); i < importantRows.reduce(max) + 1; i++) {
      displayKingdomColors.add([]);
      displayKingdomCrowns.add([]);
      for (int j = importantColumns.reduce(min); j < importantColumns.reduce(max) + 1; j++) {
        displayKingdomColors[i - importantRows.reduce(min)].add(kingdomColors[i][j]);
        displayKingdomCrowns[i - importantRows.reduce(min)].add(kingdomCrowns[i][j]);
      }
    }
    return [displayKingdomCrowns, displayKingdomColors];
  }

  Map<String, List<List<int>>> mapOfAllCoordinatesOfColors() {
    Map<String, List<List<int>>> colorCoors = {};

    // collect the coordinates of each color and add them to a map
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        String color = kingdomColors[i][j];
        if (!colorCoors.containsKey(color)) {
          colorCoors[color] = [];
        }
        colorCoors[color]!.add([i, j]);
      }
    }

    // we don't need to score grey or white coordinates
    colorCoors.remove('white');
    colorCoors.remove('grey');

    return colorCoors;
  }

  bool containsCoordinate(List<List<int>> listOfCoordinates, List<int> element) {
    for (List<int> coordinate in listOfCoordinates) {
      if (coordinate[0] == element[0] && (coordinate[1] == element[1])) {
        return true;
      }
    }
    return false;
  }

  bool compareTwoCoordinates(List<int> elementOne, List<int> elementTwo) {
    // this may not be necessary
    if (elementOne[0] == elementTwo[0] && (elementOne[1] == elementTwo[1])) {
      return true;
    }
    return false;
  }

  List<List<int>> removeCoordinateFromListOfCoordinates(List<List<int>> listOfCoordinates, List<int> element) {
    if (!containsCoordinate(listOfCoordinates, element)) {
      print('no element in list!');
    }
    List<List<int>> newListOfCoordinates = [];
    for (List<int> coordinates in listOfCoordinates) {
      if (!compareTwoCoordinates(coordinates, element)) {
        newListOfCoordinates.add(coordinates);
      }
    }
    return newListOfCoordinates;
  }

  ScoringInfo useCoordinateForScoringGroup(ScoringInfo scoringInfo) {
    List<List<int>> originalCoordinateNeighbors;
    List<List<int>> unscoredSameColorNeighbors = [];
    int row = scoringInfo.coordinate[0];
    int column = scoringInfo.coordinate[1];
    int neighborRow;
    int neighborColumn;

    // add the coordinates value to the crown number of the group:
    scoringInfo.groupScore = scoringInfo.groupScore + scoringInfo.importantKingdomCrowns[row][column];

    // add one to the size of the group for this coordinate:
    scoringInfo.groupSize = scoringInfo.groupSize + 1;

    // remove the current coordinate from the unscored ones
    if (containsCoordinate(scoringInfo.unscoredCoordinates, scoringInfo.coordinate)) {
      scoringInfo.unscoredCoordinates =
          removeCoordinateFromListOfCoordinates(scoringInfo.unscoredCoordinates, scoringInfo.coordinate);
    }

    // collect neighbors
    originalCoordinateNeighbors = [
      [row + 1, column],
      [row - 1, column],
      [row, column + 1],
      [row, column - 1],
    ];

    // see if any of said neighbors are the same color
    for (List<int> neighborCoordinate in originalCoordinateNeighbors) {
      if (containsCoordinate(scoringInfo.unscoredCoordinates, neighborCoordinate)) {
        neighborRow = neighborCoordinate[0];
        neighborColumn = neighborCoordinate[1];

        if (scoringInfo.importantKingdomColors[row][column] ==
            scoringInfo.importantKingdomColors[neighborRow][neighborColumn]) {
          // we are about to score the new coordinate so let's remove it
          scoringInfo.unscoredCoordinates =
              removeCoordinateFromListOfCoordinates(scoringInfo.unscoredCoordinates, neighborCoordinate);
          // unscoredCoordinates.remove(neighborCoordinate);
          unscoredSameColorNeighbors.add(neighborCoordinate);
        }
      }
    }
    ScoringInfo newScoringInfo = scoringInfo;

    if (newScoringInfo.unscoredCoordinates.isNotEmpty) {
      newScoringInfo.coordinate = newScoringInfo.unscoredCoordinates[0];
    }

    // do the same thing for each unscored neighbor of the same color
    for (List<int> sameColorUnscoredNeighbor in unscoredSameColorNeighbors) {
      scoringInfo.coordinate = sameColorUnscoredNeighbor;
      newScoringInfo = useCoordinateForScoringGroup(scoringInfo);
    }
    return newScoringInfo;
  }

  int score(List<List<int>> kingdomCrowns, List<List<String>> kingdomColors) {
    List kingdomDisplayReturn = kingdomDisplay(kingdomCrowns, kingdomColors);
    List<List<int>> importantKingdomCrowns = kingdomDisplayReturn[0];
    List<List<String>> importantKingdomColors = kingdomDisplayReturn[1];
    List<List<int>> unscoredCoordinates = [];

    // collect the (important) unscored coordinates that we will want to use for scoring
    for (int i = 0; i < importantKingdomColors.length; i++) {
      for (int j = 0; j < importantKingdomColors[i].length; j++) {
        if (importantKingdomColors[i][j] != 'white' && (importantKingdomColors[i][j] != 'grey')) {
          unscoredCoordinates.add([i, j]);
        }
      }
    }

    if (unscoredCoordinates.isEmpty) return 0;

    int score = 0;
    ScoringInfo scoringInfo =
        ScoringInfo(importantKingdomCrowns, importantKingdomColors, unscoredCoordinates, 0, 0, unscoredCoordinates[0]);
    while (scoringInfo.unscoredCoordinates.isNotEmpty) {
      scoringInfo.groupSize = 0;
      scoringInfo.groupScore = 0;
      scoringInfo = useCoordinateForScoringGroup(scoringInfo);
      score = score + scoringInfo.groupScore * scoringInfo.groupSize;
    }

    return score; // return the sum of all scores
  }
}

class ScoringInfo {
  List<List<int>> importantKingdomCrowns;
  List<List<String>> importantKingdomColors;
  List<List<int>> unscoredCoordinates;
  int groupScore;
  int groupSize;
  List<int> coordinate;
  ScoringInfo(
    this.importantKingdomCrowns,
    this.importantKingdomColors,
    this.unscoredCoordinates,
    this.groupScore,
    this.groupSize,
    this.coordinate,
  );
}
