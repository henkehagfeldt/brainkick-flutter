import 'package:brainkick/enums/card_type.dart';
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

    Image homeImage = Image.asset('assets/images/home.png', height: 60, width: 60);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      body: Stack(
        children: [
          // Custom back button in the top left corner
          BackButton(homeImage: homeImage),
          CardRow(showExtraSpacers: showExtraSpacers, gameState: gameState),
      ]),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
    required this.homeImage,
  });

  final Image homeImage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.0, // Adjust the padding as needed
      left: 16.0, // Adjust the padding as needed
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Go back to the previous screen
        },
        child: homeImage,
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  const CardRow({
    super.key,
    required this.showExtraSpacers,
    required this.gameState,
  });

  final bool showExtraSpacers;
  final GameScreenProvider gameState;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Flex(
        direction: Axis.horizontal,
        children: [Expanded(
          flex: 5,
          child: Row(
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
        ),
      ]
      ),
    );
  }
}