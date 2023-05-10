import 'package:flame/components.dart';

class IsometricHexagonalTileMapComponent extends IsometricTileMapComponent {
  IsometricHexagonalTileMapComponent(
    super.tileset,
    super.matrix, {
    required this.surfaceHeight,
    super.destTileSize,
    super.tileHeight,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  });

  /// The height of the surface of the isometric tile.
  final double surfaceHeight;

  /// The size of the surface of the isometric tile.
  Vector2 get surfaceSize => Vector2(effectiveTileSize.x, surfaceHeight);

  @override
  Vector2 getBlockRenderPositionInts(int i, int j) {
    return Vector2((i - j) * surfaceSize.x * 0.75, (i + j) * surfaceSize.y / 2);
  }

  @override
  Vector2 getBlockCenterPosition(Block block) {
    final result = getBlockRenderPosition(block) +
        (Vector2(effectiveTileSize.x / 2,
            effectiveTileSize.y - effectiveTileHeight - surfaceSize.y / 2)
          ..multiply(scale));
    return result;
  }

  @override
  Vector2 cartToIso(Vector2 p) {
    // I'm not sure if this works as intended...
    final double y =
        p.y - 0.5 * surfaceSize.y * (p.x / (0.75 * surfaceSize.x)).floor();
    final double x = p.x + 0.75 * surfaceSize.x * (y / surfaceSize.y).floor();
    return Vector2(x, y);
  }

  @override
  Vector2 isoToCart(Vector2 p) {
    // I'm not sure if this works as intended...
    final double x = p.x - 0.75 * surfaceSize.x * (p.y / surfaceSize.y).floor();
    final double y =
        p.y + 0.5 * surfaceSize.y * (x / (0.75 * surfaceSize.x)).floor();

    return Vector2(x, y);
  }

  @override
  Block getBlock(Vector2 p) {
    final Vector2 cartPos = p - position - Vector2(0, effectiveTileHeight);
    final Vector2 isoPos = cartToIso(cartPos);

    final Vector2 sector = Vector2(
      (isoPos.x / (0.75 * surfaceSize.x)),
      (isoPos.y / surfaceSize.y),
    )..floor();

    /// Relative to sector
    final Vector2 relPos = cartPos -
        isoToCart(Vector2(
          sector.x * 0.75 * surfaceSize.x,
          sector.y * surfaceSize.y,
        ));

    final double corner = surfaceSize.x / 8 + surfaceSize.y / 4; // Corner size
    // Adjust for corners
    if (relPos.x + relPos.y <= corner) sector.x--;
    if (relPos.x + surfaceSize.y - relPos.y <= corner) sector.y++;

    return Block(sector.x.toInt(), sector.y.toInt());
  }
}
