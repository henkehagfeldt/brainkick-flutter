import 'package:brainkick/providers/card_pack_selection_provider.dart';
import 'package:brainkick/screens/card_pack_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BrainkickApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class BrainkickApp extends StatelessWidget {
  BrainkickApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

    return ChangeNotifierProvider<CardPackSelectionProvider>(
      create: (context) => CardPackSelectionProvider(),
      child: MaterialApp(
        title: 'Brainkick',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 255, 122, 122)),
        ),
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 31, 31, 31),
          body: CardPackSelectionScreen(),
        )
      ),
    );
  }
}