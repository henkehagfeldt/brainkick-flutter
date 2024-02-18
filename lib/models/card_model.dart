import 'package:flutter/material.dart';
import 'package:brainkick/enums/card_state.dart';
import 'package:brainkick/enums/card_type.dart';

class CardModel {
  late List<String> _prompts;
  late CardType _type;
  CardState _state = CardState.idle;
  int _promptIndex = 0;
  
  CardModel(CardType type) {
    _type = type;
    _state = CardState.idle;
  }

  String getNextPrompt() {
    if (_promptIndex >= _prompts.length) {
      return "No more fun!";
    } else {
      String nextPrompt = _prompts[_promptIndex];
      _promptIndex += 1;
      return nextPrompt;
    }
  }

  void setPromptData(List<String> promptData) {
    _prompts = promptData;
  }

  CardState getState() {
    return _state;
  }

  void setState(CardState state) {
    _state = state;
  }

  Image getImage() {
    return Image.asset('assets/images/cards/${_type.value}.png');
  }
  
  String getTypeAsString() {
    return _type.value;
  }

  bool isHidden() {
    return _state == CardState.hiding;
  }

  bool isHighlighted() {
    return _state == CardState.highlightCard;
  }

  bool isShowingText() {
    return _state == CardState.displayPrompt;
  }

  bool isIdle() {
    return _state == CardState.idle;
  }

  
}