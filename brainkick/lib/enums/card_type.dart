enum CardType {
  fire,
  pingpong,
  lightning
}

extension CardTypeExtension on CardType {
  String get value {
    switch (this) {
      case CardType.fire:
        return "fire";
      case CardType.pingpong:
        return "pingpong";
      case CardType.lightning:
        return "lightning";
      default:
        return "Unknown";
    }
  }
}