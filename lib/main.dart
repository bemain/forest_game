import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InteractiveViewer(
          child: GameWidget(
            game: IsometricTileGame(),
          ),
        ),
      ),
    );
  }
}

class IsometricTileGame extends FlameGame {
  late IsometricTileMapComponent mapComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final tilesetImage = await images.load('tilemaps/sample.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(64.0),
    );

    final matrix = [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
    ];

    mapComponent = IsometricTileMapComponent(
      tileset,
      matrix,
      destTileSize: Vector2.all(32.0),
      tileHeight: 16.0,
      position: Vector2.all(200),
    );
    await add(mapComponent);
  }
}
