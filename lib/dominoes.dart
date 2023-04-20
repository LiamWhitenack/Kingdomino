class Domino {
  List<int> crowns;
  List<String> colors;
  late int value;
  bool horizontal;
  bool taken;
  Domino({required this.crowns, required this.colors, this.horizontal = true, this.taken = true});

  void rotate() {
    if (!horizontal) {
      var tempCrowns = crowns[0];
      crowns[0] = crowns[1];
      crowns[1] = tempCrowns;

      var tempColors = colors[0];
      colors[0] = colors[1];
      colors[1] = tempColors;
    }
    horizontal = !horizontal;
  }
}

List<Domino> returnEveryDominoFunction() {
  List<Domino> dominoes = [
    Domino(crowns: [0, 0], colors: ['yellow', 'yellow']),
    Domino(crowns: [0, 0], colors: ['yellow', 'yellow']),
    Domino(crowns: [0, 0], colors: ['green', 'green']),
    Domino(crowns: [0, 0], colors: ['green', 'green']),
    Domino(crowns: [0, 0], colors: ['green', 'green']),
    Domino(crowns: [0, 0], colors: ['green', 'green']),
    Domino(crowns: [0, 0], colors: ['blue', 'blue']),
    Domino(crowns: [0, 0], colors: ['blue', 'blue']),
    Domino(crowns: [0, 0], colors: ['blue', 'blue']),
    Domino(crowns: [0, 0], colors: ['pink', 'pink']),
    Domino(crowns: [0, 0], colors: ['pink', 'pink']),
    Domino(crowns: [0, 0], colors: ['brown', 'brown']),
    Domino(crowns: [0, 0], colors: ['yellow', 'green']),
    Domino(crowns: [0, 0], colors: ['yellow', 'blue']),
    Domino(crowns: [0, 0], colors: ['yellow', 'pink']),
    Domino(crowns: [0, 0], colors: ['yellow', 'brown']),
    Domino(crowns: [0, 0], colors: ['green', 'blue']),
    Domino(crowns: [0, 0], colors: ['green', 'pink']),
    Domino(crowns: [1, 0], colors: ['yellow', 'green']),
    Domino(crowns: [1, 0], colors: ['yellow', 'blue']),
    Domino(crowns: [1, 0], colors: ['yellow', 'pink']),
    Domino(crowns: [1, 0], colors: ['yellow', 'brown']),
    Domino(crowns: [1, 0], colors: ['yellow', 'purple']),
    Domino(crowns: [1, 0], colors: ['green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['green', 'blue']),
    Domino(crowns: [1, 0], colors: ['green', 'pink']),
    Domino(crowns: [1, 0], colors: ['blue', 'yellow']),
    Domino(crowns: [1, 0], colors: ['blue', 'yellow']),
    Domino(crowns: [1, 0], colors: ['blue', 'green']),
    Domino(crowns: [1, 0], colors: ['blue', 'green']),
    Domino(crowns: [1, 0], colors: ['blue', 'green']),
    Domino(crowns: [1, 0], colors: ['blue', 'green']),
    Domino(crowns: [1, 0], colors: ['pink', 'yellow']),
    Domino(crowns: [1, 0], colors: ['pink', 'blue']),
    Domino(crowns: [1, 0], colors: ['brown', 'yellow']),
    Domino(crowns: [1, 0], colors: ['brown', 'pink']),
    Domino(crowns: [1, 0], colors: ['purple', 'yellow']),
    Domino(crowns: [2, 0], colors: ['pink', 'yellow']),
    Domino(crowns: [2, 0], colors: ['pink', 'blue']),
    Domino(crowns: [2, 0], colors: ['brown', 'yellow']),
    Domino(crowns: [2, 0], colors: ['brown', 'pink']),
    Domino(crowns: [2, 0], colors: ['purple', 'yellow']),
    Domino(crowns: [2, 0], colors: ['purple', 'brown']),
    Domino(crowns: [2, 0], colors: ['purple', 'brown']),
    Domino(crowns: [3, 0], colors: ['purple', 'yellow']),
  ];

  for (int i = 0; i < dominoes.length; i++) {
    dominoes[i].value = i;
  }

  return dominoes;
}

List<Domino> drawNSortedDominoes(int n, List<Domino> dominoes) {
  dominoes.shuffle();
  // select drawn dominoes
  List<Domino> drawnDominoes = dominoes.sublist(0, n);
  for (int i = 0; i < drawnDominoes.length; i++) {
    // remove drawn dominoes from the box
    dominoes.remove(drawnDominoes[i]);
  }
  // sort the dominoes by their value
  drawnDominoes.sort((a, b) => a.value.compareTo(b.value));
  drawnDominoes = drawnDominoes.map((domino) => domino).toList();
  return drawnDominoes;
}
