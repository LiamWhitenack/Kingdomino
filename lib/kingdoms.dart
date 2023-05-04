// ignore_for_file: avoid_print

import 'dart:core';
import 'check_valid_position.dart';
import 'dominoes.dart';
import 'dart:math';

class Kingdom {
  // these are the values of the kingdom that WILL NOT be lost
  late List<List<int>> kingdomCrowns;
  late List<List<String>> kingdomColors;
  // these are the same thing but they often have a domino moving around on them
  late List<List<int>> newKingdomCrowns;
  late List<List<String>> newKingdomColors;
  // these are the dominoes in the kingdom's queue
  Domino? domino;
  Domino? dominoInPurgatory;
  // this is true if the newKingdomCrowns == kingdomCrowns
  late bool fullyUpdated;
  // these are the coordinates the piece is being placed at
  late int i;
  late int j;
  // Every kingdom needs a unique color to choose from to distinguish themselves
  // during gameplay
  final String color;

  // initialize the kingdom as a 9x9 grid with one spot filled in
  Kingdom(this.color) {
    kingdomCrowns = List.generate(9, (_) => List.filled(9, -1));
    kingdomColors = List.generate(9, (_) => List.filled(9, 'noColor'));
    kingdomCrowns[4][4] = 0;
    kingdomColors[4][4] = 'grey';
    fullyUpdated = true;
  }

  // this is used to make sure when we make changes to kingdomColors we don't
  // also change newKingdomColors
  List<List<String>> deepCopyColors(List<List<String>> source) {
    return source.map((e) => e.toList()).toList();
  }

  List<List<int>> deepCopyCrowns(List<List<int>> source) {
    return source.map((e) => e.toList()).toList();
  }

  // this is used to put a piece at a particular position and change only the
  // newKingdomCrowns and Colors
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

  // this synchronized old and new grid values - cannot be reversed
  void updateBoard() {
    checkValidPlacementAtPositionIJ(this, domino!, i, j);
    kingdomCrowns = newKingdomCrowns;
    kingdomColors = newKingdomColors;
    fullyUpdated = false;
  }

  // this only returns the rows and columns that we care about as two separate
  // lists
  List<List<int>> getImportantRowsAndColumns(List<List<String>> kingdomColors) {
    List<int> rows = [];
    List<int> columns = [];

    // Check each row for partial completion
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (kingdomColors[i][j] != 'noColor') {
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
    // these are the crowns and colors that will be displayed
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

  // this function isn't being used for anything right now
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

    // we don't need to score grey or noColor coordinates
    colorCoors.remove('noColor');
    colorCoors.remove('grey');

    return colorCoors;
  }

  // this function is used to see if item is in list since .contains() uses
  // memory pointer equality instead of value equality
  bool containsCoordinate(List<List<int>> listOfCoordinates, List<int> element) {
    for (List<int> coordinate in listOfCoordinates) {
      if (coordinate[0] == element[0] && (coordinate[1] == element[1])) {
        return true;
      }
    }
    return false;
  }

  // this function evaluates if two coordinates are the same in value
  bool compareTwoCoordinates(List<int> elementOne, List<int> elementTwo) {
    // this may not be necessary
    if (elementOne[0] == elementTwo[0] && (elementOne[1] == elementTwo[1])) {
      return true;
    }
    return false;
  }

  // this function also gets around memory problems like before
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

  // This function will return ScoringInfo for a group of the same color using
  // the group that contains given coordinate. If there are still groups left
  // to score, the function will score the rest as well
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

    // get a new coordinate to start the process over with
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

  // use this function to return the score of a given layout
  int score(List<List<int>> kingdomCrowns, List<List<String>> kingdomColors) {
    // only use the rows and columns we care about
    List kingdomDisplayReturn = kingdomDisplay(kingdomCrowns, kingdomColors);
    List<List<int>> importantKingdomCrowns = kingdomDisplayReturn[0];
    List<List<String>> importantKingdomColors = kingdomDisplayReturn[1];
    List<List<int>> unscoredCoordinates = [];

    // collect the (important) unscored coordinates that we will want to use for
    // scoring
    for (int i = 0; i < importantKingdomColors.length; i++) {
      for (int j = 0; j < importantKingdomColors[i].length; j++) {
        if (importantKingdomColors[i][j] != 'noColor' && (importantKingdomColors[i][j] != 'grey')) {
          unscoredCoordinates.add([i, j]);
        }
      }
    }

    // if there isn't anything to score return 0 as the score
    if (unscoredCoordinates.isEmpty) return 0;

    int score = 0;
    ScoringInfo scoringInfo =
        ScoringInfo(importantKingdomCrowns, importantKingdomColors, unscoredCoordinates, 0, 0, unscoredCoordinates[0]);
    while (scoringInfo.unscoredCoordinates.isNotEmpty) {
      // this routine scores every possible group
      scoringInfo.groupSize = 0;
      scoringInfo.groupScore = 0;
      scoringInfo = useCoordinateForScoringGroup(scoringInfo);
      score = score + scoringInfo.groupScore * scoringInfo.groupSize;
    }

    return score; // return the sum of all scores
  }
}

class ScoringInfo {
  // the crowns we care about
  List<List<int>> importantKingdomCrowns;
  // the colors we care about

  List<List<String>> importantKingdomColors;
  // all the coordinates that haven't been scored yet
  List<List<int>> unscoredCoordinates;
  // the value of the pieces of one group
  int groupScore;
  // the size of given group
  int groupSize;
  // the coordinate to start scoring at
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
