import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class PostOfficeComponent extends SpriteComponent with HasGameReference {
  PostOfficeComponent({required Vector2 position}) 
      : super(position: position, size: Vector2.all(80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('spr_post_office.png');
    add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2));
  }
}

