import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;

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

class IsometricTileGame extends FlameGame with MouseMovementDetector {
  late IsometricTileMapComponent mapComponent;
  late Selector selector;

  static const double destTileSize = 64.0;
  static const double tileHeight = destTileSize / 2;
  final Vector2 topLeft = Vector2.all(200);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final tilesetImage = await images.load('tilemaps/sample.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(64.0),
    );

    final matrix = [
      [2, 2, 2, 2, 2, 2],
      [2, 2, 2, 2, 2, 2],
      [2, 2, 2, 2, 2, 2],
      [2, 2, 2, 2, 2, 2],
      [2, 2, 2, 2, 2, 2],
      [2, 2, 2, 2, 2, 2],
    ];

    mapComponent = IsometricTileMapComponent(
      tileset,
      matrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
    );
    await add(mapComponent);

    final selectorImage = await images.load('selector.png');
    selector = Selector(destTileSize, selectorImage);
    await add(selector);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final Vector2 screenPosition = info.eventPosition.game;
    final Block block = mapComponent.getBlock(screenPosition);

    selector.show = mapComponent.containsBlock(block);
    selector.position.setFrom(
      topLeft + mapComponent.getBlockRenderPosition(block),
    );
  }
}

class Selector extends SpriteComponent {
  bool show = true;

  Selector(double size, Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2.all(32.0)),
          size: Vector2.all(size),
        );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }

    super.render(canvas);
  }
}
