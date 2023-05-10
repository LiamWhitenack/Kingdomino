import 'package:flutter/material.dart';

Widget grey2x2Grid(double width) {
  Container box = Container(color: Colors.black38, height: width, width: width);
  Row row = Row(children: [box, const SizedBox(width: 1), box]);
  return Column(children: [row, const SizedBox(height: 1), row]);
}

Widget grey2x1Grid(double width) {
  Container box = Container(color: Colors.black38, height: width, width: width);
  Row row = Row(children: [box, const SizedBox(width: 1), box]);
  return row;
}
