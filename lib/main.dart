import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forest_game/game/game_view.dart';

void main() {
  runApp(const MainApp());
}

final gameViewKey = GlobalKey<GameViewState>(debugLabel: "GameView");

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const List<List<TerrainType>> tiles = [
    [TerrainType.forest, TerrainType.forest, TerrainType.forest],
    [TerrainType.forest, TerrainType.forest, TerrainType.forest],
    [TerrainType.forest, TerrainType.forest, TerrainType.forest],
    [TerrainType.forest, TerrainType.forest, TerrainType.forest],
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GameView(
                key: gameViewKey,
                tiles: tiles,
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: FilledButton(
                    onPressed: () {
                      gameViewKey.currentState
                          ?.moveFocusCenterTo(Point(200, 0));
                    },
                    child: const Text("Test Button")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
