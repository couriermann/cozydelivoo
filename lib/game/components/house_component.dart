import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class HouseComponent extends SpriteComponent with HasGameReference {
  bool isDelivered = false;

  HouseComponent({required Vector2 position}) 
      : super(position: position, size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('spr_house_target.png');
    add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2)); 
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isDelivered) {
      // Draw a checkmark or indicator
      final paint = Paint()..color = Colors.green.withValues(alpha: 0.5);
      canvas.drawCircle((size / 2).toOffset(), size.x / 3, paint);
    }
  }
  
  void deliver() {
    isDelivered = true;
  }
  
  void reset() {
    isDelivered = false;
  }
}
