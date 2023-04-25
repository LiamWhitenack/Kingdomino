// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kingdomino/player_placement_grid.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'check_valid_position.dart';
import 'domino_selection_interface.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class PlayerInteractionInterface extends StatefulWidget {
  final List<Domino> dominoesInTheBox;
  const PlayerInteractionInterface({
    super.key,
    required this.dominoesInTheBox,
  });

  @override
  State<PlayerInteractionInterface> createState() => _PlayerInteractionInterfaceState();
}

class _PlayerInteractionInterfaceState extends State<PlayerInteractionInterface> {
  // variables for use in interface
  // ===========================================================================

  // this is the domino selected (but not chosen) by the current player
  Domino? activePlayersSelectedDomino;

  // this is the list of players (or kingdoms) in the game
  List<Kingdom> kingdoms = [
    Kingdom('grey'),
    Kingdom('purple'),
    Kingdom('yellow'),
    Kingdom('blue'),
  ];

  // this is the index of the player turn, used as an index for the kingdoms
  // list
  int kingdomTurnIndex = 0;

  // this widget (which will immediately change) displays the score and the
  //potential score increase of placing a piece in a given spot
  Widget scoreTextWidget = const Text('');

  // these variables represent the row and column the domino is being placed in.
  // they have a lot of instances and were probably executed poorly
  int i = 5;
  int j = 4;

  // this is used to open, close, and hide the sliding up panel for selecting
  // dominoes
  PanelController panelController = PanelController();

  // these are the domino selections available
  List<Domino> dominoOptionsForSelectionColumnOne = [];
  List<Domino> dominoOptionsForSelectionColumnTwo = [];

  // PlayerInteractionInterface functions!!
  // ===========================================================================

  // when a piece is chosen,
  // 1. move the kingdom's selected pieces into the appropriate positions
  // 2. rebuild the interface (if necessary) to show the new grid
  void onDominoChosenByActivePlayer(Domino domino) {
    activePlayersSelectedDomino = domino;
    setState(() {
      if (kingdoms[kingdomTurnIndex].dominoInPurgatory == null) {
        kingdoms[kingdomTurnIndex].dominoInPurgatory = domino;
        kingdomTurnIndex = (kingdomTurnIndex + 1) % 4;
        return;
      }
      kingdoms[kingdomTurnIndex].domino = kingdoms[kingdomTurnIndex].dominoInPurgatory!;
      kingdoms[kingdomTurnIndex].dominoInPurgatory = domino;
    });
  }

  // when a piece is selected,
  // 1. move the kingdom's selected pieces into the appropriate positions
  // 2. rebuild the interface (if necessary) to show the new grid
  void onDominoSelectedByActivePlayer(Domino domino) {
    setState(() {
      activePlayersSelectedDomino = domino;
    });
  }

  // this function organizes the kingdoms list when a new round starts
  void organizeKingdomsByColumnOrder(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    // I only care about the column that I'm not working on
    List<Domino> workingDominoOptions = [];
    if (dominoOptionsForSelectionColumnOne.isEmpty) {
      workingDominoOptions = dominoOptionsForSelectionColumnTwo;
    } else if (dominoOptionsForSelectionColumnTwo.isEmpty) {
      workingDominoOptions = dominoOptionsForSelectionColumnOne;
    }

    // get the order of selections by collecting the colors, which we will soon use to
    List<String> colorsInOrder = [];
    for (Domino domino in workingDominoOptions) {
      colorsInOrder.add(domino.whiteIfPieceNotTakenElseColor);
    }

    if (colorsInOrder.isEmpty) {
      return;
    }

    List<Kingdom> newOrderOfKingdoms = [];
    for (String color in colorsInOrder) {
      for (Kingdom kingdom in kingdoms) {
        if (kingdom.color == color) {
          newOrderOfKingdoms.add(kingdom);
        }
      }
    }

    kingdoms = newOrderOfKingdoms;
  }

  // Building the game
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    List<Domino> dominoesInTheBox = widget.dominoesInTheBox;

    scoreTextWidget = Text(
        '${kingdoms[kingdomTurnIndex].score(kingdoms[kingdomTurnIndex].kingdomCrowns, kingdoms[kingdomTurnIndex].kingdomColors)}');

    PlayerPlacementGrid playerPlacementGrid = PlayerPlacementGrid(
      i: i,
      j: j,
      kingdom: kingdoms[kingdomTurnIndex],
      domino: kingdoms[kingdomTurnIndex].domino,
      scoreTextWidget: scoreTextWidget,
    );

    TextButton placePieceButton = TextButton(
      onPressed: () async {
        i = kingdoms[kingdomTurnIndex].i;
        j = kingdoms[kingdomTurnIndex].j;
        // make sure that the placement of the piece is legitimate, otherwise show message explaining what went wrong
        String errorMessage =
            checkValidPlacementAtPositionIJ(kingdoms[kingdomTurnIndex], kingdoms[kingdomTurnIndex].domino!, i, j);
        if (errorMessage != '') {
          print(errorMessage);
          return;
        }

        // mark the domino as whiteIfPieceNotTakenElseColor so that it doesn't appear anymore
        if (kingdoms[kingdomTurnIndex].domino != null) {
          kingdoms[kingdomTurnIndex].domino!.placed = true;
        }

        // Update the score and the board
        scoreTextWidget = Text(
            '${kingdoms[kingdomTurnIndex].score(kingdoms[kingdomTurnIndex].kingdomCrowns, kingdoms[kingdomTurnIndex].kingdomColors)}');
        kingdoms[kingdomTurnIndex].updateBoard();

        // if this isn't included the same piece can be placed twice
        kingdoms[kingdomTurnIndex].domino = null;

        // bring back the selection interface
        await panelController.show();
        panelController.open();
        kingdomTurnIndex = (kingdomTurnIndex + 1) % 4;
        setState(() {});
      },
      child: const Text("Place"),
    );

    DominoSelectionInterface dominoSelectionInterface = DominoSelectionInterface(
      kingdoms: kingdoms,
      kingdomSelectingIndex: kingdomTurnIndex,
      activePlayersSelectedDomino: activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: onDominoChosenByActivePlayer,
      organizeKingdomsByColumnOrder: organizeKingdomsByColumnOrder,
      panelController: panelController,
      dominoesInTheBox: dominoesInTheBox,
      dominoOptionsForSelectionColumnOne: dominoOptionsForSelectionColumnOne,
      dominoOptionsForSelectionColumnTwo: dominoOptionsForSelectionColumnTwo,
    );

    // this is purely for the UI
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      collapsed: Container(
        decoration: BoxDecoration(borderRadius: radius, color: Colors.white),
        margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
        height: 75,
        child: const Center(
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: Colors.grey,
          ),
        ),
      ),
      slideDirection: SlideDirection.UP,
      minHeight: 75,
      maxHeight: MediaQuery.of(context).size.height,
      controller: panelController,
      borderRadius: radius,

      // inside the panel
      panelBuilder: (scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ],
        ),
        margin: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            dominoSelectionInterface,
            const SizedBox(
              height: 75,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      // outside the panel
      body: Column(
        children: [
          const SizedBox(height: 250),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                // if there's no domino selected there's no need to show all of the bells and whistles
                playerPlacementGrid,
                // kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : playerPlacementGrid,
                kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : placePieceButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
