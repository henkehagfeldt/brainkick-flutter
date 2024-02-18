import 'package:brainkick/enums/card_state.dart';
import 'package:brainkick/enums/card_type.dart';
import 'package:brainkick/models/card_model.dart';
import 'package:flutter/material.dart';

class CardPackModel {

  CardPackModel({required this.packId, required this.assetBundle}) {
    initialize();
  }

  final String packId;
  final AssetBundle assetBundle;

  bool initialized = false;

  Map<CardType, CardModel> cardModelMap = {
    CardType.fire: CardModel(CardType.fire), 
    CardType.pingpong: CardModel(CardType.pingpong), 
    CardType.lightning: CardModel(CardType.lightning)
  };

  CardModel getCard(CardType type) {
    return cardModelMap[type]!;
  }

  void setAllHiddenExcept(CardType exception) {
    cardModelMap.forEach((type, model) {
      if(type != exception) {
        model.setState(CardState.hiding);
      }
    });
  }

  void setAllIdleExcept(CardType exception) {
    cardModelMap.forEach((type, model) {
      if(type != exception) {
        model.setState(CardState.idle);
      }
    });
  }

  void initialize() {
    if(initialized) {return;} else {initialized = true;}

    _readCardPromptsFromAssets(cardModelMap[CardType.fire]!);
    _readCardPromptsFromAssets(cardModelMap[CardType.pingpong]!);
    _readCardPromptsFromAssets(cardModelMap[CardType.lightning]!);
  }

  void _readCardPromptsFromAssets(CardModel cardModel) async {
    String loadedData;
    try {
      loadedData = await assetBundle.loadString('assets/packs/$packId/${cardModel.getTypeAsString()}.txt');
    } catch (e) {
      print("Error loading asset: $e");
      return;
    }

    loadedData = loadedData.toUpperCase();
    List<String> listData = loadedData.split("\n");
    listData.shuffle();
    cardModel.setPromptData(listData);
    //notifyListeners();
  }
}