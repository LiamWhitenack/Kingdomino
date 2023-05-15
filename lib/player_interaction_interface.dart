// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:kingdomino/colors.dart';
import 'package:kingdomino/player_placement_grid.dart';
import 'package:kingdomino/show_alert_dialogue.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'check_valid_position.dart';
import 'domino_selection_interface.dart';
import 'dominoes.dart';
import 'kingdoms.dart';

class PlayerInteractionInterface extends StatefulWidget {
  final List<Domino> dominoesInTheBox;
  final int numberOfRounds;
  final int numberOfUniqueKingdoms;
  List<Kingdom> kingdoms;
  final double interfaceHeight;
  final double interfaceWidth;
  PlayerInteractionInterface({
    super.key,
    required this.dominoesInTheBox,
    required this.numberOfRounds,
    required this.kingdoms,
    required this.numberOfUniqueKingdoms,
    required this.interfaceHeight,
    required this.interfaceWidth,
  });

  @override
  State<PlayerInteractionInterface> createState() => _PlayerInteractionInterfaceState();
}

class _PlayerInteractionInterfaceState extends State<PlayerInteractionInterface> {
  // variables for use in interface
  // ===========================================================================

  // this value counts the round number. It starts at zero because a round is
  // (for the purpose of programming) the part where a domino is placed and no
  // dominos are placed on the first rotation.
  int roundCounter = 0;

  // this is the domino selected (but not chosen) by the current player
  Domino? activePlayersSelectedDomino;

  bool showTextButton = false;

  // this is the index of the player turn, used as an index for the widget.kingdoms
  // list
  int kingdomTurnIndex = 0;

  // this widget (which will immediately change) displays the score and the
  //potential score increase of placing a domino in a given spot
  Widget scoreTextWidget = const Text('');

  // this is used to open, close, and hide the sliding up panel for selecting
  // dominoes
  PanelController panelController = PanelController();

  // these are the domino selections available
  List<Domino> dominoOptionsForSelectionColumnOne = [];
  List<Domino> dominoOptionsForSelectionColumnTwo = [];

  // PlayerInteractionInterface functions!!
  // ===========================================================================

  // when a domino is chosen,
  // 1. move the kingdom's selected dominos into the appropriate positions
  // 2. rebuild the interface (if necessary) to show the new grid
  Kingdom onDominoChosenByActivePlayer(Domino domino) {
    int dominoesInPurgatoryMinimum = 1;
    if (widget.numberOfUniqueKingdoms == 2) {
      dominoesInPurgatoryMinimum = 2;
    }
    Kingdom kingdomToReturn = widget.kingdoms[kingdomTurnIndex];

    setState(() {
      int numberOfTurnsInARound = widget.kingdoms.length;
      if (widget.kingdoms.length == 2) numberOfTurnsInARound = 4;

      // if they don't need to place a domino
      if (widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory.length < dominoesInPurgatoryMinimum) {
        widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory.add(domino);
        kingdomTurnIndex = (kingdomTurnIndex + 1) % numberOfTurnsInARound;
        if (kingdomTurnIndex == 0) {
          roundCounter++;
          widget.kingdoms =
              organizeKingdomsByColumnOrder(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
        }
        return;
      }

      // if they do need to place a domino, move a domino up the queue
      kingdomToReturn.domino = kingdomToReturn.dominoesInPurgatory[0];
      kingdomToReturn.dominoesInPurgatory.remove(kingdomToReturn.dominoesInPurgatory[0]);
      kingdomToReturn.dominoesInPurgatory.add(domino);

      List<int> coordinates =
          findTheHighestScoringSpot(widget.kingdoms[kingdomTurnIndex], widget.kingdoms[kingdomTurnIndex].domino!);
      if (coordinates.isEmpty) {
        endTurnWithoutPlacingADomino(widget.kingdoms[kingdomTurnIndex], panelController);
        setState(() {});
        showAlertDialog(context, 'Domino Lost', 'That domino will not fit on your kingdom');
      }
    });

    return kingdomToReturn;
  }

  void endTurn(Kingdom kingdom, PanelController panelController) async {
    int numberOfTurnsInARound = widget.kingdoms.length;
    if (widget.kingdoms.length == 2) numberOfTurnsInARound = 4;

    // bring back the selection interface
    if (roundCounter < widget.numberOfRounds - 1) {
      await panelController.show();
      panelController.open();
    }

    // mark the domino as noColorIfDominoNotTakenElseColor so that it doesn't appear anymore
    widget.kingdoms[kingdomTurnIndex].domino!.placed = true;

    // if this isn't included the same domino can be placed twice
    widget.kingdoms[kingdomTurnIndex].domino = null;

    kingdomTurnIndex = (kingdomTurnIndex + 1) % numberOfTurnsInARound;

    if (kingdomTurnIndex == 0) {
      roundCounter++;
      widget.kingdoms =
          organizeKingdomsByColumnOrder(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
    }

    setState(() {});
  }

  void endTurnWithoutPlacingADomino(Kingdom kingdom, PanelController panelController) async {
    // mark the domino as noColorIfDominoNotTakenElseColor so that it doesn't appear anymore
    kingdom.domino!.placed = true;

    // if this isn't included the same domino can be placed twice
    widget.kingdoms[kingdomTurnIndex].domino = null;

    kingdomTurnIndex = (kingdomTurnIndex + 1) % widget.kingdoms.length;

    if (kingdomTurnIndex == 0) {
      roundCounter++;
      widget.kingdoms =
          organizeKingdomsByColumnOrder(dominoOptionsForSelectionColumnOne, dominoOptionsForSelectionColumnTwo);
    }
  }

  // when a domino is selected,
  // 1. move the kingdom's selected dominos into the appropriate positions
  // 2. rebuild the interface (if necessary) to show the new grid
  void onDominoSelectedByActivePlayer(Domino domino) {
    setState(() {
      activePlayersSelectedDomino = domino;
      updateShowTextButton(true);
    });
  }

  void updateKingdomsList(List<Kingdom> newList) {
    widget.kingdoms = newList;
  }

  void updateShowTextButton(bool newTextButtonValue) {
    showTextButton = newTextButtonValue;
  }

  bool dominoOptionsAreAllSelected(List<Domino> dominoOptions) {
    int numberOfSelectedButNotPlacedDominoes = 0;
    for (Domino domino in dominoOptions) {
      if (domino.taken && !domino.placed) numberOfSelectedButNotPlacedDominoes++;
    }
    return numberOfSelectedButNotPlacedDominoes == widget.kingdoms.length;
  }

  // this function organizes the widget.kingdoms list when a new round starts
  List<Kingdom> organizeKingdomsByColumnOrder(
    List<Domino> dominoOptionsForSelectionColumnOne,
    List<Domino> dominoOptionsForSelectionColumnTwo,
  ) {
    // I only care about the column that I'm not working on
    List<Domino> workingDominoOptions = [];
    if (dominoOptionsAreAllSelected(dominoOptionsForSelectionColumnOne)) {
      workingDominoOptions = dominoOptionsForSelectionColumnOne;
    } else if (dominoOptionsAreAllSelected(dominoOptionsForSelectionColumnTwo)) {
      workingDominoOptions = dominoOptionsForSelectionColumnTwo;
    } else {
      return widget.kingdoms;
    }

    // get the order of selections by collecting the colors, which we will soon use to
    List<String> colorsInOrder = [];
    for (Domino domino in workingDominoOptions) {
      if (!domino.placed) {
        colorsInOrder.add(domino.noColorIfDominoNotTakenElseColor);
      }
    }

    if (colorsInOrder.isEmpty) {
      return widget.kingdoms;
    }

    List<Kingdom> newOrderOfKingdoms = [];
    for (String color in colorsInOrder) {
      for (Kingdom kingdom in widget.kingdoms) {
        if (kingdom.color == color) {
          newOrderOfKingdoms.add(kingdom);
          break;
        }
      }
    }

    for (Kingdom kingdom in newOrderOfKingdoms) {
      kingdom.dominoesInPurgatory.sort((a, b) => a.value.compareTo(b.value));
    }

    return newOrderOfKingdoms;
  }

  // Building the game
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    // these variables represent the row and column the domino is being placed in.
    // they have a lot of instances and were probably executed poorly
    int i = 5;
    int j = widget.kingdoms.length;
    if (widget.kingdoms[kingdomTurnIndex].domino != null) {
      List<int> coordinates =
          findTheHighestScoringSpot(widget.kingdoms[kingdomTurnIndex], widget.kingdoms[kingdomTurnIndex].domino!);
      if (coordinates.isEmpty) {
        // endTurnWithoutPlacingADomino(widget.kingdoms[kingdomTurnIndex], panelController);
        showAlertDialog(context, 'Domino Lost', 'That domino will not fit on your kingdom');
      } else {
        i = coordinates[0];
        j = coordinates[1];
      }
    }

    List<int> rgboValues = colors[widget.kingdoms[kingdomTurnIndex].color]!;
    Color backgroundColor = Color.fromRGBO(
      rgboValues[0],
      rgboValues[1],
      rgboValues[2],
      1.0,
    );

    List<Domino> dominoesInTheBox = widget.dominoesInTheBox;

    scoreTextWidget = Text(
      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      'Score: ${widget.kingdoms[kingdomTurnIndex].score(widget.kingdoms[kingdomTurnIndex].kingdomCrowns, widget.kingdoms[kingdomTurnIndex].kingdomColors)}',
    );

    PlayerPlacementGrid playerPlacementGrid = PlayerPlacementGrid(
      i: i,
      j: j,
      kingdom: widget.kingdoms[kingdomTurnIndex],
      domino: widget.kingdoms[kingdomTurnIndex].domino,
      scoreTextWidget: scoreTextWidget,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );

    DominoSelectionInterface dominoSelectionInterface = DominoSelectionInterface(
      kingdoms: widget.kingdoms,
      kingdomSelectingIndex: kingdomTurnIndex,
      showTextButton: showTextButton,
      activePlayersSelectedDomino: activePlayersSelectedDomino,
      onDominoSelectedByActivePlayer: onDominoSelectedByActivePlayer,
      onDominoChosenByActivePlayer: onDominoChosenByActivePlayer,
      organizeKingdomsByColumnOrder: organizeKingdomsByColumnOrder,
      updateKingdomsList: updateKingdomsList,
      updateShowTextButton: updateShowTextButton,
      panelController: panelController,
      dominoesInTheBox: dominoesInTheBox,
      dominoOptionsForSelectionColumnOne: dominoOptionsForSelectionColumnOne,
      dominoOptionsForSelectionColumnTwo: dominoOptionsForSelectionColumnTwo,
    );

    TextButton placeDominoButton = TextButton(
      onPressed: () async {
        i = widget.kingdoms[kingdomTurnIndex].i;
        j = widget.kingdoms[kingdomTurnIndex].j;
        // make sure that the placement of the domino is legitimate, otherwise show message explaining what went wrong
        String errorMessage = checkValidPlacementAtPositionIJ(
            widget.kingdoms[kingdomTurnIndex], widget.kingdoms[kingdomTurnIndex].domino!, i, j);
        if (errorMessage != '') {
          showAlertDialog(context, 'Invalid Position', errorMessage);
          return;
        }

        // Update the score and the board
        scoreTextWidget = Text(
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            'Score: ${widget.kingdoms[kingdomTurnIndex].score(widget.kingdoms[kingdomTurnIndex].kingdomCrowns, widget.kingdoms[kingdomTurnIndex].kingdomColors)}');
        widget.kingdoms[kingdomTurnIndex].updateBoard();

        endTurn(widget.kingdoms[kingdomTurnIndex], panelController);
      },
      child: const Text(
        'Place',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
    );

    // String getWinningKingdomString(List<Kingdom> kingdoms) {
    //   List<Kingdom> kingdomsListWithoutDuplicates = [];
    //   for (Kingdom kingdom in kingdoms) {
    //     if (!kingdomsListWithoutDuplicates.contains(kingdom)) {
    //       kingdomsListWithoutDuplicates.add(kingdom);
    //     }
    //   }
    //   kingdoms = kingdomsListWithoutDuplicates;
    //   int maxScore = 0;
    //   //
    //   String winningColor = '';
    //   String endString = 'kingdom wins!!';
    //   for (int i = 0; i < kingdoms.length; i++) {
    //     if (kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors) > maxScore) {
    //       maxScore = kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors);
    //       winningColor = kingdoms[i].color;
    //       endString = 'kingdom wins!!';
    //     } else if (kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors) == maxScore) {
    //       winningColor = '$winningColor and ${kingdoms[i].color}';
    //       endString = 'kingdoms win!!';
    //     }
    //   }
    //   return 'The $winningColor $endString';
    // }

    String getWinningKingdomName(List<Kingdom> kingdoms) {
      List<Kingdom> kingdomsListWithoutDuplicates = [];
      for (Kingdom kingdom in kingdoms) {
        if (!kingdomsListWithoutDuplicates.contains(kingdom)) {
          kingdomsListWithoutDuplicates.add(kingdom);
        }
      }
      kingdoms = kingdomsListWithoutDuplicates;
      int maxScore = 0;
      //
      String winningName = '';
      String endString = 'kingdom wins!!';
      for (int i = 0; i < kingdoms.length; i++) {
        if (kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors) > maxScore) {
          maxScore = kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors);
          winningName = kingdoms[i].name;
          endString = ' wins!!';
        } else if (kingdoms[i].score(kingdoms[i].kingdomCrowns, kingdoms[i].kingdomColors) == maxScore) {
          winningName = '$winningName and ${kingdoms[i].name}';
          endString = ' win!!';
        }
      }
      return '$winningName $endString';
    }

    // this is purely for the UI
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    if (roundCounter == widget.numberOfRounds - 1) {
      List<int> coordinates = [];
      // start endgame

      while (coordinates.isEmpty) {
        if (widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory.isNotEmpty) {
          widget.kingdoms[kingdomTurnIndex].domino = widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory[0];

          // remove the domino from purgatory
          widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory
              .remove(widget.kingdoms[kingdomTurnIndex].dominoesInPurgatory[0]);
        } else {
          return Center(
            child: Text(
              getWinningKingdomName(widget.kingdoms),
            ),
          );
        }

        coordinates =
            findTheHighestScoringSpot(widget.kingdoms[kingdomTurnIndex], widget.kingdoms[kingdomTurnIndex].domino!);
        if (coordinates.isEmpty) {
          endTurnWithoutPlacingADomino(widget.kingdoms[kingdomTurnIndex], panelController);
        } else {
          i = coordinates[0];
          j = coordinates[1];
        }
      }

      playerPlacementGrid = PlayerPlacementGrid(
        i: i,
        j: j,
        kingdom: widget.kingdoms[kingdomTurnIndex],
        domino: widget.kingdoms[kingdomTurnIndex].domino,
        scoreTextWidget: scoreTextWidget,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      );

      rgboValues = colors[widget.kingdoms[kingdomTurnIndex].color]!;
      backgroundColor = Color.fromRGBO(rgboValues[0], rgboValues[1], rgboValues[2], 0.5);

      return Container(
        color: backgroundColor,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                children: [
                  // if there's no domino selected there's no need to show all of the bells and whistles
                  playerPlacementGrid,
                  // widget.kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : playerPlacementGrid,
                  widget.kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : placeDominoButton,
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (roundCounter == widget.numberOfRounds) {
      return Center(
        child: Text(getWinningKingdomName(widget.kingdoms)),
      );
    }

    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      collapsed: Container(
        decoration: BoxDecoration(borderRadius: radius, color: Colors.white),
        margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
        height: MediaQuery.of(context).size.height / 10,
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
      // borderRadius: radius,

      // inside the panel
      panelBuilder: (scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              spreadRadius: 7.0,
              color: backgroundColor,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
        margin: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 16),
            Text(
              "${widget.kingdoms[kingdomTurnIndex].name}'s turn",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(rgboValues[0], rgboValues[1], rgboValues[2], 0.75),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 16),
            SizedBox(
              height: 634,
              child: dominoSelectionInterface,
            ),
          ],
        ),
      ),

      // outside the panel
      body: Container(
        color: Color.fromRGBO(rgboValues[0], rgboValues[1], rgboValues[2], 0.5),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            SizedBox(
              child: Column(
                children: [
                  playerPlacementGrid,
                  const SizedBox(height: 40),
                  // widget.kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : playerPlacementGrid,
                  widget.kingdoms[kingdomTurnIndex].domino == null ? const SizedBox() : placeDominoButton,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
