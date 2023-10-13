import 'package:application/enums/card_state.dart';
import 'package:application/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/brainkick_card.dart';
import 'package:flutter/services.dart';
import 'package:application/enums/card_type.dart';

void main() {
  runApp(BrainKickApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class BrainKickApp extends StatelessWidget {
  const BrainKickApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

    return ChangeNotifierProvider(
      create: (context) => MainState(),
      child: MaterialApp(
        title: 'BrainKick',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 255, 122, 122)),
        ),
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 66, 66, 66),
          body: GameScreen(),
        )
      ),
    );
  }
}



class MainState extends ChangeNotifier {

  CardType? currentlyHighlighted;

  Map<CardType, CardModel> cardModelMap = {
    CardType.fire: CardModel(CardType.fire), 
    CardType.pingpong: CardModel(CardType.pingpong), 
    CardType.lightning: CardModel(CardType.lightning)
  };

  bool initialized = false;

  CardModel getCard(CardType type) {
    return cardModelMap[type]!;
  }

  void initialize(context) {
    if(initialized) {return;} else {initialized = true;}

    _readCardPromptsFromAssets(context, cardModelMap[CardType.fire]!);
    _readCardPromptsFromAssets(context, cardModelMap[CardType.pingpong]!);
    _readCardPromptsFromAssets(context, cardModelMap[CardType.lightning]!);
  }

  void _readCardPromptsFromAssets(BuildContext context, CardModel cardModel) async {
    final assetBundle = DefaultAssetBundle.of(context);

    String loadedData;
    try {
      loadedData = await assetBundle.loadString('assets/text/${cardModel.getTypeAsString()}.txt');
    } catch (e) {
      print("Error loading asset: $e");
      return;
    }

    loadedData = loadedData.toUpperCase();
    List<String> listData = loadedData.split("\n");
    listData.shuffle();
    cardModel.setPromptData(listData);
    notifyListeners();
  }

  bool isHighlighted(CardType cardType) {
    return cardModelMap[cardType]!.getState() == CardState.highlightCard;
  }

  bool isShowing(CardType cardType) {
    return !isHidden(cardType); 
  }

  bool isHidden(CardType cardType) {
    return cardModelMap[cardType]!.isHidden();
  }

  bool noCardHighlighted() {
    return currentlyHighlighted == null;
  }

  void refresh() {
    print("Refreshing with new value ${cardModelMap[CardType.fire]!.getState()}");
    notifyListeners();
  }

  void transitionState(CardType cardType) {
    print("Performing State Transition");
    CardModel cardModel = cardModelMap[cardType]!;
    switch(cardModel.getState()) {
      case CardState.choosingCard:
        cardModel.setState(CardState.highlightCard);
        currentlyHighlighted = cardType;
        cardModelMap.forEach((type, model) {
          if(type != cardType) {
            model.setState(CardState.hiding);
          }
        });
        break;
      case CardState.highlightCard:
        cardModel.setState(CardState.displayPrompt);
        break;
      case CardState.displayPrompt:
        cardModel.setState(CardState.choosingCard);
        currentlyHighlighted = null;
        cardModelMap.forEach((type, model) {
          if(type != cardType) {
            model.setState(CardState.choosingCard);
          }
        });
        break;
      default:
        print("Unknown State Transition Occurred");
        break;
    }
    notifyListeners();
  }

}

class GameScreen extends StatefulWidget {

  const GameScreen({
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    bool showExtraSpacers = mainState.noCardHighlighted();

    print("Rebuilding Main");

    return Consumer<MainState>(
      builder: (context, state, child) {

      /*
      print("In Main Fire State: ${state.cardModelMap[CardType.fire]!.getState()}");
      print("Fire: ${state.isHighlighted(CardType.fire)}");
      print("Fire Show: ${state.isShowing(CardType.fire)}");
      print("PingPong: ${state.isHighlighted(CardType.pingpong)}");
      print("PingPong Show: ${state.isShowing(CardType.pingpong)}");
      print("Lightning: ${state.isHighlighted(CardType.lightning)}");
      print("Lightning Show: ${state.isShowing(CardType.lightning)}");
      */

      return Row(
        children: [
          Spacer(
            flex: showExtraSpacers ? 6 : 10,
          ),
          Expanded(
            flex: state.isShowing(CardType.fire) ? 6 : 0,
            child: Visibility(
              visible: state.isShowing(CardType.fire), 
              child: CardColumn(cardType: CardType.fire,))
          ),
          if (showExtraSpacers) Spacer(flex: 3,),
          Expanded(
            flex: state.isShowing(CardType.pingpong) ? 6 : 0,
            child: Visibility(
              visible: state.isShowing(CardType.pingpong),
              child: CardColumn(cardType: CardType.pingpong,))
          ),
          if (showExtraSpacers) Spacer(flex: 3,),
          Expanded(
            flex: state.isShowing(CardType.lightning) ? 6 : 0,
            child: Visibility(
              visible: state.isShowing(CardType.lightning),
              child: CardColumn(cardType: CardType.lightning,))
          ),
          Spacer(
            flex: showExtraSpacers ? 6 : 10,
          ),
        ],
      );
    }
  );
  }
}

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