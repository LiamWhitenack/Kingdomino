import 'package:flutter/material.dart';
import 'dominoes.dart';
import 'colors.dart';

List<Widget> getImages(int n, int m, List<List<int>> values, List<List<String>> colors) {
  List<Widget> images = [];
  // LIAM THE SQUARE SIZE IS RIGHT HERE
  double squareSize = 60.0;

  // use a double nester for loop to make a copy of every square
  for (int i = 0; i < n; i++) {
    List<Widget> row = [];
    for (int j = 0; j < m; j++) {
      String color = colors[i][j];
      String value = values[i][j] > 0 ? '${values[i][j]}' : '';
      // get the image with this very important function
      Widget squareImage = showDominoSection(color, squareSize);

      // display the text (this may have a new font later)
      Widget overlayImage = Text(
        value,
        style: const TextStyle(
          fontSize: 45,
          color: Color.fromRGBO(245, 245, 245, 0.9),
        ),
      );

      // stack the text and the square
      Widget stack = Stack(
        alignment: AlignmentDirectional.center,
        children: [
          squareImage,
          overlayImage,
        ],
      );

      // Add a border to the stack
      Widget borderedStack = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: stack,
      );
      // add each image to a row
      row.add(Expanded(child: borderedStack));
    }
    // add each row to a column
    images.add(Row(children: row));
  }

  return images;
}

Widget displayDomino(Domino domino) {
  // this function returns an entire domino instead of just one part of it

  Widget square;
  Widget value;
  List<Widget> images = [];

  for (int i = 0; i < 2; i++) {
    square = showDominoSection(domino.colors[i], 60);
    value = Text(
      domino.crowns[i] > 0 ? '${domino.crowns[i]}' : '',
      style: const TextStyle(
        fontSize: 45,
        color: Color.fromRGBO(245, 245, 245, 0.9),
      ),
    );

    if (i == 1) {
      images.add(const SizedBox(
        width: 2,
      ));
    }

    images.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(245, 245, 245, 0),
            width: 0.5,
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            square,
            value,
          ],
        ),
      ),
    );
  }
  return Row(children: images);
}

Widget displayDominoInABox(Domino domino, double interfaceHeight, double interfaceWidth,
    {String colorOfTheBox = 'noColor'}) {
  // this just puts the domino display in a box of a certain color,
  // in this case a player's color
  List? color = colors[colorOfTheBox];
  int r = color![0];
  int g = color[1];
  int b = color[2];

  return Container(
    height: 85,
    width: 140,
    color: Color.fromRGBO(r, g, b, 0.5),
    child: Center(
      child: SizedBox(
        width: 125,
        child: displayDomino(domino),
      ),
    ),
  );
}

Widget showDominoSection(String color, double size) {
  // this shows ONE PART of a domino
  double opacity = 1.0;
  List rgboValues = colors[color]!;
  int counter = 0;
  for (int value in rgboValues) {
    if (value == 255) {
      counter++;
    }
  }
  if (counter == 3) opacity = 0.0;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Color.fromRGBO(
        rgboValues[0], // R
        rgboValues[1], // G
        rgboValues[2], // B
        opacity, // O
      ),
    ),
  );
}
