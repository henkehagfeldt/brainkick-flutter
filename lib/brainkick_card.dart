import 'dart:async';
import 'package:application/models/cardModel.dart';
import 'package:provider/provider.dart';
import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:application/enums/card_state.dart';
import 'package:application/enums/card_type.dart';

class BrainKickCard extends StatefulWidget {
  BrainKickCard({required this.cardType});
  CardType cardType;
  
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

  void triggerCard(MainState mainState) {
    mainState.transitionState(widget.cardType);
    CardModel cardData = mainState.getCard(widget.cardType);

    if(cardData.getState() == CardState.displayPrompt) {
      rotationDurationMs = rotateTextInDurationMs;
      startRotationToText();
    } else if(cardData.getState() == CardState.choosingCard) {
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
      final mainState = Provider.of<MainState>(context);
      CardModel cardData = mainState.getCard(widget.cardType);
      mainState.initialize(context);
      return GestureDetector(
        onTap: () => {triggerCard(mainState)},
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
            child: _showingText ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY(3.14),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'StudentsTeacher',
                      fontSize: 28),
                    cardData.getNextPrompt(),
                  ),
                )
              ),
            )
            : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: cardData.getImage(),
              )
            ),
          ),
        ),
      );
  }
}