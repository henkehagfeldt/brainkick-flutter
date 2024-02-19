import 'package:brainkick/models/card_pack_model.dart';
import 'package:brainkick/providers/game_screen_provider.dart';
import 'package:brainkick/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPack extends StatelessWidget {
  const CardPack({
    super.key,
    required this.packId,
    required this.packTitle
  });

  final String packId;
  final String packTitle;

  triggerCard(BuildContext context) {
    
    // Navigate to the HomeScreen
    Navigator.push(
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
          aspectRatio: 12/9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/packs/$packId/cover.png')),
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Shadow color with opacity
                  spreadRadius: 3, // Extend the shadow to all sides by the specified radius
                  blurRadius: 10, // Blur radius for the shadow
                  offset: Offset(10, 10), // Horizontal and vertical offset of the shadow
                ),
              ],
            ),
            
            child: Column(children: [
              Spacer(flex: 4),
              Expanded(flex: 1, child: Text(
                style: TextStyle(
                  fontSize: 25, 
                  fontFamily: 'AlteHaasGrotesk'), 
                packTitle))
            ]),
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