import 'package:brainkick/enums/card_state.dart';
import 'package:brainkick/enums/card_type.dart';
import 'package:brainkick/models/card_model.dart';
import 'package:brainkick/models/card_pack_model.dart';
import 'package:flutter/material.dart';

class GameScreenProvider with ChangeNotifier {

  CardPackModel cardPack;
  GameScreenProvider({required this.cardPack});

  bool _isPackSelected = false;
  bool get isPackSelected => _isPackSelected;
  
  CardType? currentlyHighlighted;
  bool initialized = false;
  

  void selectPack() {
    _isPackSelected = true;
    notifyListeners();
  }

  void transitionState(CardType cardType) {
    
    print("Performing State Transition");
    CardModel cardModel = cardPack.getCard(cardType);
    
    switch(cardModel.getState()) {
      case CardState.idle:
        cardModel.setState(CardState.highlightCard);
        currentlyHighlighted = cardType;
        cardPack.setAllHiddenExcept(cardType);
        break;
      case CardState.highlightCard:
        cardModel.setState(CardState.displayPrompt);
        break;
      case CardState.displayPrompt:
        cardModel.setState(CardState.idle);
        currentlyHighlighted = null;
        cardPack.setAllIdleExcept(cardType);
        break;
      default:
        print("Unknown State Transition Occurred");
        break;
    }
    notifyListeners();
  }

  bool isHighlighted(CardType cardType) {
    return cardPack.getCard(cardType).isHighlighted();
  }

  bool isShowing(CardType cardType) {
    return !isHidden(cardType); 
  }

  bool isHidden(CardType cardType) {
    return cardPack.getCard(cardType).isHidden();
  }

  bool noCardHighlighted() {
    return currentlyHighlighted == null;
  }

  CardModel getCard(CardType cardType) {
    return cardPack.getCard(cardType);
  }

  void refresh() {
    //print("Refreshing with new value ${cardModelMap[CardType.fire]!.getState()}");
    notifyListeners();
  }
}