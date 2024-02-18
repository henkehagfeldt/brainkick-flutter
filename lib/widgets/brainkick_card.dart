import 'dart:async';
import 'package:brainkick/models/card_model.dart';
import 'package:brainkick/providers/game_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:brainkick/enums/card_type.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BrainKickCard extends StatefulWidget {
  BrainKickCard({required this.cardType});
  final CardType cardType;
  
  @override
  State<BrainKickCard> createState() => _BrainKickCardState();
}

class _BrainKickCardState extends State<BrainKickCard> {
  
  bool _showingText = false;
  Timer? _transitionToTextTimer;
  Timer? _transitionBackTimer;

  double yRotationValue = 0;
  int rotateTextInDurationMs = 600;
  int rotateImageInDurationMs = 200;
  int rotationDurationMs = 600;

  String currentCardPrompt = "";

  void triggerCard(GameScreenProvider gameState) {
    gameState.transitionState(widget.cardType);
    CardModel cardData = gameState.getCard(widget.cardType);

    if(cardData.isShowingText()) {
      rotationDurationMs = rotateTextInDurationMs;
      startRotationToText();
      currentCardPrompt = cardData.getNextPrompt().trim();
    } else if(cardData.isIdle()) {
      rotationDurationMs = rotateImageInDurationMs;
      startRotationToImage();
    } 
  }

  void startRotationToText() {
      yRotationValue = 3.14;
      _transitionToTextTimer = Timer(Duration(milliseconds: rotateTextInDurationMs ~/ 2), () => setState(() {
          _showingText = true;
        })
      );
  }

  void startRotationToImage() {
    yRotationValue = 0;
    _transitionBackTimer = Timer(Duration(milliseconds: rotateImageInDurationMs ~/ 2), () => setState(() {
        _showingText = false;
      })
    );
  }

  @override
  void dispose() {
    _transitionToTextTimer?.cancel();
    _transitionBackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      final gameState = Provider.of<GameScreenProvider>(context);
      CardModel cardData = gameState.getCard(widget.cardType);

      return GestureDetector(
        onTap: () {triggerCard(gameState);},
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height * 0.7
          ),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: AnimatedContainer(
              duration: Duration(milliseconds: rotationDurationMs),
              transformAlignment: Alignment.center,
              transform: Matrix4.identity()
              ..rotateY(yRotationValue),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _showingText ? 
                CardText(width: width, currentCardPrompt: currentCardPrompt)
                : CardImage(cardImage: cardData.getImage()),
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

class CardText extends StatelessWidget {
  const CardText({
    super.key,
    required this.width,
    required this.currentCardPrompt,
  });

  final double width;
  final String currentCardPrompt;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateY(3.14),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            maxLines: 5,
            minFontSize: (width/50).ceilToDouble(),
            maxFontSize: (width/30).ceilToDouble(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'StudentsTeacher'),
            currentCardPrompt,
          )
        ),
      ),
    );
  }
}