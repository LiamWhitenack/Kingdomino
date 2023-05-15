import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPlayerNamesWidget extends StatelessWidget {
  final int numberOfPlayers;

  final TextEditingController maroonController;
  final TextEditingController forestController;
  final TextEditingController navyController;
  final TextEditingController yellowController;
  const InputPlayerNamesWidget({
    required this.numberOfPlayers,
    required this.maroonController,
    required this.forestController,
    required this.navyController,
    required this.yellowController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget maroon = SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[  ]')),
        ],
        maxLength: 12,
        controller: maroonController,
        autocorrect: false,
        decoration: const InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
          labelText: "Maroon Player Name",
        ),
      ),
    );

    Widget forest = SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[  ]')),
        ],
        maxLength: 12,
        controller: forestController,
        autocorrect: false,
        decoration: const InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
          labelText: "Forest Player Name",
        ),
      ),
    );

    Widget navy = SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[  ]')),
        ],
        maxLength: 12,
        controller: navyController,
        autocorrect: false,
        decoration: const InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
          labelText: "Navy Player Name",
        ),
      ),
    );

    Widget yellow = SizedBox(
      width: 250,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[  ]')),
        ],
        maxLength: 12,
        controller: yellowController,
        autocorrect: false,
        decoration: const InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
              width: 0.5,
            ),
          ),
          labelText: "Yellow Player Name",
        ),
      ),
    );

    return Column(
      children: [
        maroon,
        const SizedBox(height: 25),
        numberOfPlayers >= 2 ? forest : const SizedBox(),
        const SizedBox(height: 25),
        numberOfPlayers >= 3 ? navy : const SizedBox(),
        const SizedBox(height: 25),
        numberOfPlayers >= 4 ? yellow : const SizedBox(),
        const SizedBox(height: 50),
      ],
    );
  }
}
