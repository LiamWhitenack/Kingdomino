import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/kingdoms.dart';
import 'dart:math';

String checkValidPlacementAtPositionIJ(Kingdom kingdom, Domino domino, int i, int j) {
  if (!checkWithinBounds(kingdom, domino, i, j)) return 'The piece must be placed within a 5x5 grid!';
  if (!checkPlacedInEmptySpot(kingdom, domino, i, j)) return 'The piece must be placed in an empty spot!';
  if (!checkHasNeighbors(kingdom, domino, i, j)) return 'The piece does not have any neighbors!';
  if (!checkHasSameColorNeighbors(kingdom, domino, i, j)) {
    return 'The piece does not have any neighbors of the same type!';
  }
  return '';
}

String checkValidMovementAtPositionIJ(Kingdom kingdom, Domino domino, int i, int j) {
  if (!checkWithinBounds(kingdom, domino, i, j)) return 'The piece must be placed within a 5x5 grid!';
  return '';
}

bool checkWithinBounds(Kingdom kingdom, Domino domino, int i, int j) {
  if (i >= 8 && !domino.horizontal) return false; // if this row number is always too high
  if (i >= 9) return false; // if this row number is always too high
  if (j >= 8 && domino.horizontal) return false; // if this column number is always too high
  if (j >= 9) return false; // if this column number is always too high
  if (i <= -1) return false; // if this row number is always too low
  if (j <= -1) return false; // if this column number is always too low
  List<int> rows;
  List<int> columns;
  // see how many rows (m) and columns (n) we need to display (minimum one)
  List rowsAndColumns = kingdom.getImportantRowsAndColumns(kingdom.newKingdomColors);
  rows = rowsAndColumns[0];
  // add the new row we would be moving the piece to (depending on if the piece is horizontal or now)
  rows.add(i);
  rows.add(!domino.horizontal ? i + 1 : i);
  columns = rowsAndColumns[1];
  // do the same for the columns
  columns.add(j);
  columns.add(domino.horizontal ? j + 1 : j);
  // don't let the difference between the greatest and least row and column be greater than 4
  int difference = rows.reduce(max) - rows.reduce(min);
  difference = difference.abs();
  if (difference > 4) {
    return false;
  }
  difference = columns.reduce(max) - columns.reduce(min);
  difference = difference.abs();
  if (difference > 4) {
    return false;
  }
  return true;
}

bool checkHasNeighbors(Kingdom kingdom, Domino domino, int i, int j) {
  List neighbors = [];

  if (!domino.horizontal) {
    neighbors.add([i, j - 1]); // west
    neighbors.add([i + 1, j - 1]); // west south
    neighbors.add([i - 1, j]); // north
    neighbors.add([i + 2, j]); // east east
    neighbors.add([i, j + 1]); // east
    neighbors.add([i + 1, j + 1]); // east south
  } else {
    neighbors.add([i, j - 1]); // west
    neighbors.add([i - 1, j]); // north
    neighbors.add([i + 1, j]); // south
    neighbors.add([i - 1, j + 1]); // east north
    neighbors.add([i + 1, j + 1]); // east south
    neighbors.add([i, j + 2]); // east east
  }

  List deleteList = [];
  for (List pair in neighbors) {
    if (pair.contains(-1)) deleteList.add(pair);
    if (pair.contains(9)) deleteList.add(pair);
    if (pair.contains(10)) deleteList.add(pair);
  }

  for (List pair in deleteList) {
    neighbors.removeWhere((item) => item == pair);
  }

  for (List pair in neighbors) {
    if (kingdom.newKingdomColors[pair[0]][pair[1]] != 'noColor') return true;
  }

  // No neighbors were found
  return false;
}

bool checkHasSameColorNeighbors(Kingdom kingdom, Domino domino, int i, int j) {
  // The domino has two sections, so we need to find the neighbors for each color individually
  List<List<int>> coordinates = [
    [i, j]
  ];
  if (domino.horizontal) {
    coordinates.add([i, j + 1]);
  } else {
    coordinates.add([i + 1, j]);
  }
  int counter = 0;
  for (List<int> coordinate in coordinates) {
    List neighbors = [];

    neighbors.add([coordinate[0] - 1, coordinate[1]]); // north
    neighbors.add([coordinate[0], coordinate[1] - 1]); // west
    neighbors.add([coordinate[0], coordinate[1] + 1]); // east
    neighbors.add([coordinate[0] + 1, coordinate[1]]); // south

    List deleteList = [];
    for (List pair in neighbors) {
      if (pair.contains(-1)) deleteList.add(pair);
      if (pair.contains(9)) deleteList.add(pair);
    }

    for (List pair in deleteList) {
      neighbors.removeWhere((item) => item == pair);
    }

    for (List pair in neighbors) {
      if ((kingdom.newKingdomColors[pair[0]][pair[1]] == domino.colors[counter]) |
          (kingdom.newKingdomColors[pair[0]][pair[1]] == 'grey')) return true; // found a grey or same color neighbor
    }
    counter++;
  }
  // No neighbors were found
  return false;
}

bool checkPlacedInEmptySpot(Kingdom kingdom, Domino domino, int i, int j) {
  List<List<int>> coors = [
    [i, j],
    [i + (domino.horizontal ? 0 : 1), j + (domino.horizontal ? 1 : 0)]
  ];
  for (List<int> coor in coors) {
    if (kingdom.kingdomCrowns[coor[0]][coor[1]] >= 0) {
      return false;
    }
  }
  return true;
}

List<int> findTheFirstAvailableSpot(Kingdom kingdom, Domino domino) {
  // I'm not sure why this needs to be here, but sometimes I have
  // newKingdomColors that are mysteriously different than their correct value
  kingdom.newKingdomColors = kingdom.kingdomColors;
  kingdom.newKingdomCrowns = kingdom.kingdomCrowns;

  // record the important rows and columns
  List rowsAndColumns = kingdom.getImportantRowsAndColumns(kingdom.newKingdomColors);
  List<int> rows = rowsAndColumns[0];
  List<int> columns = rowsAndColumns[1];

  int maxRow = rows.reduce(max);
  int minRow = rows.reduce(min);
  int maxColumn = columns.reduce(max);
  int minColumn = columns.reduce(min);

  // first assume that the domino is oriented horizontally and try to find a spot
  for (int i = minRow - 1; i < maxRow + 1; i++) {
    for (int j = minColumn - 2; j < maxColumn + 1; j++) {
      if (checkValidPlacementAtPositionIJ(kingdom, domino, i, j) == '') {
        return [i, j];
      }
    }
  }

  domino.rotate();
  // then assume that the domino is oriented vertically and try to find a spot
  for (int i = minRow - 2; i < maxRow + 1; i++) {
    for (int j = minColumn - 1; j < maxColumn + 1; j++) {
      if (checkValidPlacementAtPositionIJ(kingdom, domino, i, j) == '') {
        return [i, j];
      }
    }
  }

  // keep going with every orientation
  domino.rotate();
  for (int i = minRow - 1; i < maxRow + 1; i++) {
    for (int j = minColumn - 2; j < maxColumn + 1; j++) {
      if (checkValidPlacementAtPositionIJ(kingdom, domino, i, j) == '') {
        return [i, j];
      }
    }
  }

  domino.rotate();
  for (int i = minRow - 2; i < maxRow + 1; i++) {
    for (int j = minColumn - 1; j < maxColumn + 1; j++) {
      if (checkValidPlacementAtPositionIJ(kingdom, domino, i, j) == '') {
        return [i, j];
      }
    }
  }

  // if none of the spots work, the piece needs to be discarded.
  // For now just return an empty list
  return [];
}
