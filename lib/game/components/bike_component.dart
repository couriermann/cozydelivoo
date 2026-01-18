import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../cozy_courier_game.dart';
import '../managers/audio_manager.dart';
import 'obstacle_component.dart';
import 'house_component.dart';

class BikeComponent extends SpriteComponent with CollisionCallbacks, HasGameReference<CozyCourierGame> {
  BikeComponent() : super(size: Vector2.all(48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('spr_bike.png');
    add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ObstacleComponent) {
      AudioManager.playSfx(AudioManager.sfxCrash);
      game.onLose("Crashed into obstacle!");
    } else if (other is HouseComponent) {
      if (!other.isDelivered) {
        AudioManager.playSfx(AudioManager.sfxMailDeliver);
        other.deliver();
        game.onHouseDelivered();
      }
    }
  }
}
