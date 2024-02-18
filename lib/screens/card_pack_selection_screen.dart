import 'package:flutter/material.dart';
import '../widgets/card_pack.dart';

class CardPackSelectionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Access the provider

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      body: Center(
        // Just an example button to select a pack
        child: Row(children: [
          Spacer(
            flex: 6,
          ),
          CardPack(packId: 'pack_1'),
          Spacer(
            flex: 6,
          ),
          CardPack(packId: 'pack_2'),
          Spacer(
            flex: 6,
          ),
          CardPack(packId: 'pack_3'),
          Spacer(
            flex: 6,
          ),
        ])
      ),
    );
  }
}
