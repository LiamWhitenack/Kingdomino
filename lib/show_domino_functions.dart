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
      // Widget squareImage = Image.asset(
      //   'images/$color.png',
      //   fit: BoxFit.cover,
      //   width: squareSize,
      //   height: squareSize,
      //   opacity: color == 'white' ? const AlwaysStoppedAnimation(0) : const AlwaysStoppedAnimation(1),
      // );
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
    square = showDominoSection(domino.colors[i], 40);
    value = Text(
      domino.crowns[i] > 0 ? '${domino.crowns[i]}' : '',
      style: const TextStyle(
        fontSize: 25,
        color: Color.fromRGBO(245, 245, 245, 0),
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
          children: [square, value],
        ),
      ),
    );
  }
  return Row(children: images);
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
