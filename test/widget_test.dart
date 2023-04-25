// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

void main() {
  List<int> testList = [1, 2, 3, 4];

  for (int i in testList) {
    if (!testList.contains(5)) {
      testList.add(5);
    }
    print(i);
  }
}

List<List<int>> getImportantRowsAndColumns(List<List<int>> grid) {
  List<int> rows = [];
  List<int> columns = [];

  // Check each row for partial completion
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (grid[i][j] > -1) {
        rows.add(i);
        columns.add(j);
      }
    }
  }
  rows = rows.toSet().toList();
  columns = columns.toSet().toList();
  return [rows, columns];
}
