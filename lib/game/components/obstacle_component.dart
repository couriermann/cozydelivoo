import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

enum ObstacleType {
  dog,
  fence,
  puddle,
  tree
}

class ObstacleComponent extends SpriteComponent with HasGameReference {
  final ObstacleType type;

  ObstacleComponent({
    required Vector2 position, 
    required Vector2 size,
    required this.type,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    String spriteName;
    bool isCircular = false;

    switch (type) {
      case ObstacleType.dog:
        spriteName = 'spr_obstacle_dog.png';
        isCircular = true;
        break;
      case ObstacleType.fence:
        spriteName = 'spr_obstacle_fence.png';
        isCircular = false;
        break;
      case ObstacleType.puddle:
        spriteName = 'spr_obstacle_puddle.png';
        isCircular = true;
        break;
      case ObstacleType.tree:
        spriteName = 'spr_obstacle_tree.png';
        isCircular = false; // or true depending on shape
        break;
    }

    sprite = await game.loadSprite(spriteName);

    if (isCircular) {
      add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2));
    } else {
      add(RectangleHitbox(size: size * 0.8, anchor: Anchor.center, position: size / 2));
    }
  }
}
