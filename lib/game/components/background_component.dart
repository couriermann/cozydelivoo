import 'package:flame/components.dart';
import '../cozy_courier_game.dart';

class BackgroundComponent extends PositionComponent with HasGameReference<CozyCourierGame> {
  static const double tileSize = 64;
  
  BackgroundComponent() : super(priority: -1); // Render behind everything

  @override
  Future<void> onLoad() async {
    await _buildBackground();
  }

  Future<void> _buildBackground() async {
    final grassSprite = await game.loadSprite('env_tile_grass.png');
    final pathSprite = await game.loadSprite('env_tile_path.png');
    
    final cols = (game.size.x / tileSize).ceil() + 1;
    final rows = (game.size.y / tileSize).ceil() + 1;
    
    // Get the post office position (start position) in tile coordinates
    final startTileX = (game.currentLevelData.startPos.x * game.size.x / tileSize).floor();
    final startTileY = (game.currentLevelData.startPos.y * game.size.y / tileSize).floor();
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Check if this tile is near the post office (create a small path area)
        final bool isPathTile = _isNearPostOffice(col, row, startTileX, startTileY);
        
        add(SpriteComponent(
          sprite: isPathTile ? pathSprite : grassSprite,
          position: Vector2(col * tileSize, row * tileSize),
          size: Vector2.all(tileSize),
        ));
      }
    }
  }

  bool _isNearPostOffice(int col, int row, int startTileX, int startTileY) {
    // Create a 3x3 area of path tiles around the post office
    final dx = (col - startTileX).abs();
    final dy = (row - startTileY).abs();
    return dx <= 1 && dy <= 1;
  }
}
