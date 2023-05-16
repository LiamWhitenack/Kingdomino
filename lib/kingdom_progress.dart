import 'package:kingdomino/player_placement_grid.dart';
import 'colors.dart';
import 'kingdoms.dart';
import 'package:flutter/material.dart';

void showKingdomProgress(BuildContext context, List<Kingdom> kingdoms) {
  List<Kingdom> kingdomsListWithoutDuplicates = [];
  for (Kingdom kingdom in kingdoms) {
    if (!kingdomsListWithoutDuplicates.contains(kingdom)) {
      kingdomsListWithoutDuplicates.add(kingdom);
    }
  }

  List listOfWidgetsToDisplay = [];
  for (int i = 0; i < kingdomsListWithoutDuplicates.length; i++) {
    PlayerPlacementGrid playerPlacementGrid = PlayerPlacementGrid(
      i: 0,
      j: 0,
      kingdom: kingdoms[i],
      domino: null,
      scoreTextWidget: const Text(''),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
    Color backgroundColor;
    List rgboValues = colors[kingdoms[i].color]!;
    backgroundColor = Color.fromRGBO(
      rgboValues[0],
      rgboValues[1],
      rgboValues[2],
      0.5,
    );

    listOfWidgetsToDisplay.add(Container(
      color: backgroundColor,
      child: playerPlacementGrid,
    ));
  }

  TextButton closeWindowButton = TextButton(
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
    child: const Text('close'),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [...listOfWidgetsToDisplay, closeWindowButton],
        ),
      );
    },
  );
}
