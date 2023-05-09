import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:forest_game/tile_game.dart';

enum TerrainType {
  forest,
}

class GameView extends StatefulWidget {
  const GameView({
    super.key,
    required this.tiles,
    this.gridSize = const Size.square(256),
  });

  /// 2D matrix of tiles.
  final List<List<TerrainType>> tiles;

  /// The 2-dimensional size of each tile in the grid.
  final Size gridSize;

  @override
  State<StatefulWidget> createState() => GameViewState();
}

class GameViewState extends State<GameView> with TickerProviderStateMixin {
  /// The transformation controller for the InteractiveViewer
  final TransformationController transformationController =
      TransformationController();

  /// The animation controller for moving the focus of InteractiveViewer
  late final AnimationController animationController =
      AnimationController(vsync: this);

  /// The game that this widget displays.
  late final TileGame game = TileGame(
    matrix: widget.tiles
        .map((row) => row.map((tile) => tile.index).toList())
        .toList(),
    gridSize: widget.gridSize.toVector2(),
    surfaceHeight: widget.gridSize.height / 2,
    tileHeight: widget.gridSize.height / 4,
    onTilePressed: (tile) {
      moveFocusCenterTo(game.getBlockCenterPosition(tile).toPoint());
    },
  );

  @override
  Widget build(BuildContext context) {
    /// The number of tiles wide the entire tilemap is.
    final int horizontalTiles =
        widget.tiles.length + widget.tiles[0].length - 1;

    /// Index for the column (as rendered, not as layed out in [tiles]) with the most tiles.
    final int longestColumn = widget.tiles[0].length - widget.tiles.length;

    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.symmetric(
        vertical: 1000,
        horizontal: 500,
      ),
      child: SizedBox(
        width: (horizontalTiles) * 0.75 * game.gridSize.x + game.gridSize.x / 4,
        height: game.gridSize.y +
            (widget.tiles[0].length - 1) * game.surfaceHeight +
            longestColumn.abs() * game.surfaceHeight / 2,
        child: GameWidget(game: game),
      ),
    );
  }

  /// Animate the InteractiveViewer to move so that the given [point] ends up in
  /// the top-left corner, during [duration].
  ///
  /// Optionally, a start point, [from], may be specificied.
  /// Otherwise, the animation starts at the current view.
  void moveFocusTo(
    Point point, {
    Point? from,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    Matrix4 begin = (from != null)
        ? (Matrix4.identity()..translate(from.x.toDouble(), from.y.toDouble()))
        : Matrix4.inverted(transformationController.value);
    Matrix4 end = Matrix4.identity()
      ..translate(point.x.toDouble(), point.y.toDouble());

    final Animation mapAnimation = Matrix4Tween(
      begin: begin,
      end: end,
    ).animate(animationController);
    animationController.duration = duration;

    void updateInteractiveViewer() {
      transformationController.value = Matrix4.inverted(mapAnimation.value);
    }

    mapAnimation.addListener(updateInteractiveViewer);
    mapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        mapAnimation.removeListener(updateInteractiveViewer);
      }
    });

    animationController.reset();
    animationController.forward();
  }

  /// Animate the InteractiveViewer to move so that the given [point] ends up in
  /// the center of the view.
  ///
  /// [from] is also interpreted as being in the center of the view.
  ///
  /// See [moveFocusTo].
  void moveFocusCenterTo(
    Point point, {
    Point? from,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    Point centerOffset = (MediaQuery.of(context).size / 2).toPoint();

    return moveFocusTo(
      point - centerOffset,
      from: (from == null) ? null : from - centerOffset,
      duration: duration,
    );
  }
}
