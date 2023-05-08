import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Selector extends SpriteComponent {
  bool visible = false;

  Selector(Vector2 size, Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2.all(128.0)),
          size: size,
        );

  @override
  void render(Canvas canvas) {
    if (!visible) {
      return;
    }

    super.render(canvas);
  }
}
