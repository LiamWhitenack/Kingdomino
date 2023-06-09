class Domino {
  List<int> crowns;
  List<String> colors;
  late int value;
  bool horizontal;
  String noColorIfDominoNotTakenElseColor;
  bool taken;
  bool placed;
  bool flipped;
  Domino({
    required this.crowns,
    required this.colors,
    this.horizontal = true,
    this.noColorIfDominoNotTakenElseColor = 'noColor',
    this.taken = false,
    this.placed = false,
    this.flipped = true,
  });

  void rotate() {
    if (!horizontal) {
      var tempCrowns = crowns[0];
      crowns[0] = crowns[1];
      crowns[1] = tempCrowns;

      var tempColors = colors[0];
      colors[0] = colors[1];
      colors[1] = tempColors;

      flipped = !flipped;
    }
    horizontal = !horizontal;
  }

  // rotate the domino until it's facing the right way again

  void revertToOriginalOrientation() {
    while (!horizontal | !flipped) {
      rotate();
    }
  }
}

// this is the list of every domino in the Kingdomino board game. It could be
// really interesting if there was some randomization involved with making
// dominos, especially because this is not a possibility in the physical game
List<Domino> returnEveryDominoFunction() {
  List<Domino> dominoes = [
    Domino(crowns: [0, 0], colors: ['yellow', 'yellow']),
    Domino(crowns: [0, 0], colors: ['yellow', 'yellow']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'swamp_green']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'swamp_green']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'swamp_green']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'swamp_green']),
    Domino(crowns: [0, 0], colors: ['baby_blue', 'baby_blue']),
    Domino(crowns: [0, 0], colors: ['baby_blue', 'baby_blue']),
    Domino(crowns: [0, 0], colors: ['baby_blue', 'baby_blue']),
    Domino(crowns: [0, 0], colors: ['pink', 'pink']),
    Domino(crowns: [0, 0], colors: ['pink', 'pink']),
    Domino(crowns: [0, 0], colors: ['brown', 'brown']),
    Domino(crowns: [0, 0], colors: ['yellow', 'swamp_green']),
    Domino(crowns: [0, 0], colors: ['yellow', 'baby_blue']),
    Domino(crowns: [0, 0], colors: ['yellow', 'pink']),
    Domino(crowns: [0, 0], colors: ['yellow', 'brown']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'baby_blue']),
    Domino(crowns: [0, 0], colors: ['swamp_green', 'pink']),
    Domino(crowns: [1, 0], colors: ['yellow', 'swamp_green']),
    Domino(crowns: [1, 0], colors: ['yellow', 'baby_blue']),
    Domino(crowns: [1, 0], colors: ['yellow', 'pink']),
    Domino(crowns: [1, 0], colors: ['yellow', 'brown']),
    Domino(crowns: [1, 0], colors: ['yellow', 'purple']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'yellow']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'baby_blue']),
    Domino(crowns: [1, 0], colors: ['swamp_green', 'pink']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'yellow']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'yellow']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'swamp_green']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'swamp_green']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'swamp_green']),
    Domino(crowns: [1, 0], colors: ['baby_blue', 'swamp_green']),
    Domino(crowns: [1, 0], colors: ['pink', 'yellow']),
    Domino(crowns: [1, 0], colors: ['pink', 'baby_blue']),
    Domino(crowns: [1, 0], colors: ['brown', 'yellow']),
    Domino(crowns: [1, 0], colors: ['brown', 'pink']),
    Domino(crowns: [1, 0], colors: ['purple', 'yellow']),
    Domino(crowns: [2, 0], colors: ['pink', 'yellow']),
    Domino(crowns: [2, 0], colors: ['pink', 'baby_blue']),
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
