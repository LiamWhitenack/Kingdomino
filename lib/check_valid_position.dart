import 'package:kingdomino/dominoes.dart';
import 'package:kingdomino/kingdoms.dart';
import 'dart:math';

String checkValidPlacementAtPositionIJ(Kingdom kingdom, Domino domino, int i, int j) {
  if (!checkPlacedInEmptySpot(kingdom, domino, i, j)) return 'The piece must be placed in an empty spot!';
  if (!checkWithinBounds(kingdom, domino, i, j)) return 'The piece must be placed within a 5x5 grid!';
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
  List rowsAndColumns = kingdom.getImportantRowsAndColumns();
  rows = rowsAndColumns[0];
  // add the new row we would be moving the piece to (depending on if the piece is horizontal or now)
  rows.add(!domino.horizontal ? i + 1 : i);
  columns = rowsAndColumns[1];
  // do the same for the columns
  columns.add(domino.horizontal ? j + 1 : j);
  // don't let the difference between the greatest and least row and column be greater than 4
  if (rows.reduce(max) - rows.reduce(min) > 4) return false;
  if (columns.reduce(max) - columns.reduce(min) > 4) return false;
  return true;
}

bool checkHasNeighbors(Kingdom kingdom, Domino domino, int i, int j) {
  List neighbors = [];

  if (domino.horizontal) {
    neighbors.add([i - 1, j]); // north
    neighbors.add([i - 1, j + 1]); // north east
    neighbors.add([i, j - 1]); // west
    neighbors.add([i, j + 2]); // east east
    neighbors.add([i + 1, j]); // south
    neighbors.add([i + 1, j + 1]); // south east
  } else {
    neighbors.add([i - 1, j]); // north
    neighbors.add([i, j - 1]); // west
    neighbors.add([i, j + 1]); // east
    neighbors.add([i + 1, j - 1]); // south west
    neighbors.add([i + 1, j + 1]); // south east
    neighbors.add([i + 2, j]); // south south
  }

  List deleteList = [];
  for (List pair in neighbors) {
    if (pair.contains(-1)) deleteList.add(pair);
    if (pair.contains(9)) deleteList.add(pair);
  }

  for (List pair in deleteList) {
    neighbors.removeWhere((item) => item == pair);
  }

  for (List pair in neighbors) {
    if (kingdom.newKingdomColors[pair[0]][pair[1]] != 'white') return true;
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
    if (kingdom.kingdomCrowns[coor[0]][coor[1]] >= 0) return false;
  }
  return true;
}
