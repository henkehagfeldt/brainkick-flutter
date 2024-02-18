import 'package:brainkick/enums/card_type.dart';
import 'package:brainkick/models/card_pack_model.dart';
import 'package:brainkick/providers/game_screen_provider.dart';
import 'package:brainkick/widgets/card_column.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameScreenProvider>(context);
    bool showExtraSpacers = gameState.noCardHighlighted();

    print("Rebuilding Main");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      body: Row(
          children: [
            Spacer(
              flex: showExtraSpacers ? 6 : 10,
            ),
            Expanded(
              flex: gameState.isShowing(CardType.fire) ? 6 : 0,
              child: Visibility(
                visible: gameState.isShowing(CardType.fire), 
                child: CardColumn(cardType: CardType.fire,))
            ),
            if (showExtraSpacers) Spacer(flex: 3,),
            Expanded(
              flex: gameState.isShowing(CardType.pingpong) ? 6 : 0,
              child: Visibility(
                visible: gameState.isShowing(CardType.pingpong),
                child: CardColumn(cardType: CardType.pingpong,))
            ),
            if (showExtraSpacers) Spacer(flex: 3,),
            Expanded(
              flex: gameState.isShowing(CardType.lightning) ? 6 : 0,
              child: Visibility(
                visible: gameState.isShowing(CardType.lightning),
                child: CardColumn(cardType: CardType.lightning,))
            ),
            Spacer(
              flex: showExtraSpacers ? 6 : 10,
            ),
          ],
        ),
    );
  }
}