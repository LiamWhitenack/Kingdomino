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

  // this needs to be a list of players but I'm not quite there
  Kingdom kingdomOne = Kingdom('grey');

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
    kingdomOne.dominoInPurgatory = domino;
    if (kingdomOne.dominoInPurgatory == null) {
      return;
    }
    setState(() {
      kingdomOne.domino = kingdomOne.dominoInPurgatory!;
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

  // Building the game
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    List<Domino> dominoesInTheBox = widget.dominoesInTheBox;

    scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');

    PlayerPlacementGrid playerPlacementGrid = PlayerPlacementGrid(
      i: i,
      j: j,
      kingdom: kingdomOne,
      domino: kingdomOne.domino,
      scoreTextWidget: scoreTextWidget,
    );

    TextButton placePieceButton = TextButton(
      onPressed: () {
        i = kingdomOne.i;
        j = kingdomOne.j;
        // make sure that the placement of the piece is legitimate, otherwise show message explaining what went wrong
        String errorMessage = checkValidPlacementAtPositionIJ(kingdomOne, kingdomOne.domino!, i, j);
        if (errorMessage != '') {
          print(errorMessage);
          return;
        }

        // mark the domino as whiteIfPieceNotTakenElseColor so that it doesn't appear anymore
        if (kingdomOne.domino != null) {
          kingdomOne.domino!.placed = true;
        }

        // Update the score and the board
        scoreTextWidget = Text('${kingdomOne.score(kingdomOne.kingdomCrowns, kingdomOne.kingdomColors)}');
        kingdomOne.updateBoard();

        // bring back the selection interface
        panelController.show();
        panelController.open();
        setState(() {});
      },
      child: const Text("Place"),
    );

    DominoSelectionInterface dominoSelectionInterface = DominoSelectionInterface(
      kingdomSelecting: kingdomOne,
      activePlayersSelectedDomino: activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: onDominoChosenByActivePlayer,
      panelController: panelController,
      dominoesInTheBox: dominoesInTheBox,
      dominoOptionsForSelectionColumnOne: dominoOptionsForSelectionColumnOne,
      dominoOptionsForSelectionColumnTwo: dominoOptionsForSelectionColumnTwo,
    );

    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      collapsed: Container(
        color: Colors.white,
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

      // inside the panel
      panelBuilder: (scrollController) => Stack(
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

      // outside the panel
      body: Column(
        children: [
          const SizedBox(height: 250),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                // if there's no domino selected there's no need to show all of the bells and whistles
                kingdomOne.domino == null ? const SizedBox() : playerPlacementGrid,
                kingdomOne.domino == null ? const SizedBox() : placePieceButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
