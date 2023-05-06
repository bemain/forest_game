import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:forest_game/hexagonal_isometric_tilemap.dart';
import 'package:forest_game/tile_game/selector.dart';

class TileGame extends FlameGame with MouseMovementDetector {
  TileGame({
    required this.matrix,
    required this.gridSize,
    double? tileHeight,
    double? surfaceHeight,
  })  : tileHeight = tileHeight ?? gridSize.y / 4,
        surfaceHeight = surfaceHeight ?? gridSize.y / 2;

  /// 2D matrix of tiles.
  ///
  /// `-1` means no tile
  final List<List<int>> matrix;

  /// The 2-dimensional size of each tile in the grid.
  final Vector2 gridSize;

  /// The 3-dimensional height of a tile, from the bottom to where the surface begins.
  final double tileHeight;

  /// The height of the surface area of a tile.
  final double surfaceHeight;

  late IsometricHexagonalTileMapComponent mapComponent;
  late Selector selector;

  late final Vector2 topLeft =
      Vector2((matrix.length - 1) * 0.75 * gridSize.x, 0);

  @override
  Color backgroundColor() => Colors.black;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final tilesetImage = await images.load('tilemaps/hexagonal.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(512),
    );

    mapComponent = IsometricHexagonalTileMapComponent(
      tileset,
      matrix,
      surfaceHeight: surfaceHeight,
      tileHeight: tileHeight,
      destTileSize: gridSize,
      position: topLeft,
    );
    await add(mapComponent);

    final selectorImage = await images.load('selector.png');
    selector = Selector(gridSize, selectorImage);
    await add(selector);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final Vector2 screenPosition = info.eventPosition.game;
    final Block block = mapComponent.getBlock(screenPosition);

    selector.visible = mapComponent.containsBlock(block);
    selector.position.setFrom(
      topLeft + mapComponent.getBlockRenderPosition(block),
    );
  }
}
