import 'package:brainkick/enums/card_type.dart';
import 'package:brainkick/widgets/brainkick_card.dart';
import 'package:flutter/material.dart';

class CardColumn extends StatelessWidget {
  final CardType cardType;
  
  CardColumn({
    super.key,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BrainKickCard(cardType: cardType),
      ],
    );
  }
}