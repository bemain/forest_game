import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:forest_game/tile_game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Forest Game")),
        body: Stack(
          children: [
            const Positioned.fill(
              child: GameView(
                tiles: [
                  [TerrainType.forest, TerrainType.forest, TerrainType.forest],
                  [TerrainType.forest, TerrainType.forest, TerrainType.forest],
                  [TerrainType.forest, TerrainType.forest, TerrainType.forest],
                  [TerrainType.forest, TerrainType.forest, TerrainType.forest],
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: FilledButton(
                  onPressed: () {}, child: const Text("Test Button")),
            ),
          ],
        ),
      ),
    );
  }
}

enum TerrainType {
  forest,
}

class GameView extends StatelessWidget {
  const GameView({
    super.key,
    required this.tiles,
    this.gridSize = const Size.square(128),
  });

  /// 2D matrix of tiles.
  final List<List<TerrainType>> tiles;

  /// The 2-dimensional size of each tile in the grid.
  final Size gridSize;

  @override
  Widget build(BuildContext context) {
    /// The number of tiles wide the entire tilemap is.
    final int horizontalTiles = tiles.length + tiles[0].length - 1;

    final double surfaceHeight = gridSize.height / 2;
    final double tileHeight = gridSize.height / 4;

    /// Index for the column (as rendered, not as layed out in [tiles]) with the most tiles.
    final int longestColumn = tiles[0].length - tiles.length;

    return InteractiveViewer(
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                (horizontalTiles) * 0.75 * gridSize.width + gridSize.width / 4,
            maxHeight: gridSize.height +
                (tiles[0].length - 1) * surfaceHeight +
                longestColumn.abs() * surfaceHeight / 2,
          ),
          child: GameWidget(
            game: TileGame(
              matrix: tiles
                  .map((row) => row.map((tile) => tile.index).toList())
                  .toList(),
              gridSize: gridSize.toVector2(),
              surfaceHeight: surfaceHeight,
              tileHeight: tileHeight,
            ),
          ),
        ),
      ),
    );
  }
}
