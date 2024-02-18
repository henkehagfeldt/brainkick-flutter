import 'package:flutter/material.dart';

class CardPackSelectionProvider with ChangeNotifier {
  bool _isPackSelected = false;

  void selectPack() {
    _isPackSelected = true;
    notifyListeners();
  }

  bool get isPackSelected => _isPackSelected;
}