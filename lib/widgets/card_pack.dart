import 'package:brainkick/models/card_pack_model.dart';
import 'package:brainkick/providers/game_screen_provider.dart';
import 'package:brainkick/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPack extends StatelessWidget {
  const CardPack({
    super.key,
    required this.packId
  });

  final String packId;

  triggerCard(BuildContext context) {
    
    // Navigate to the HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => GameScreenProvider(
            cardPack: CardPackModel(
              packId: packId, 
              assetBundle: DefaultAssetBundle.of(context)
            ),
          ),
          child: GameScreen(),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {triggerCard(context);},
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height * 0.4
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: CardImage(cardImage: Image.asset('assets/packs/$packId/cover.png')),
          ),
        ),
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({
    super.key,
    required this.cardImage,
  });

  final Image cardImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: cardImage,
      )
    );
  }
}