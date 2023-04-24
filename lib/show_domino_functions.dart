import 'package:flutter/material.dart';

import 'dominoes.dart';
import 'colors.dart';
import 'package:flutter/cupertino.dart';

List<Widget> getImages(int n, int m, List<List<int>> values, List<List<String>> colors) {
  List<Widget> images = [];
  double squareSize = 60.0;

  for (int i = 0; i < n; i++) {
    List<Widget> row = [];
    for (int j = 0; j < m; j++) {
      String color = colors[i][j];
      String value = values[i][j] > 0 ? '${values[i][j]}' : '';
      Widget squareImage = showDominoSection(color, squareSize);

      Widget overlayImage = Text(
        value,
        style: const TextStyle(
          fontSize: 45,
          color: Color.fromRGBO(245, 245, 245, 0.9),
        ),
      );

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
            color: const Color.fromRGBO(245, 245, 245, 0),
            width: 2,
          ),
        ),
        child: stack,
      );

      row.add(Expanded(child: borderedStack));
    }
    images.add(Row(children: row));
  }
  return images;
}

Widget displayDomino(Domino domino) {
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

Widget displayDominoInABox(Domino domino, {String colorOfTheBox = 'white'}) {
  List? color = colors[colorOfTheBox];
  int r = color![0];
  int g = color[1];
  int b = color[2];
  double opacity = color[3];

  return Container(
    height: 90,
    width: 180,
    color: Color.fromRGBO(r, g, b, opacity),
    child: Center(
      child: SizedBox(
        width: 124,
        child: displayDomino(domino),
      ),
    ),
  );
}

Widget showDominoSection(String color, double size) {
  List rgboValues = colors[color]!;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Color.fromRGBO(
        rgboValues[0], // R
        rgboValues[1], // G
        rgboValues[2], // B
        rgboValues[3], // O
      ),
      // borderRadius: BorderRadius.circular(size /), // Replace with your desired border radius
    ),
  );
}
