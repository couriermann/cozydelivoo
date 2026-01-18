import 'package:flame/components.dart';
import '../game/components/obstacle_component.dart';

class LevelData {
  final int id;
  final double inkLimit;
  final double timeLimit; // Time limit in seconds for planning phase
  final Vector2 startPos; // Normalized (0.0 - 1.0)
  final List<Vector2> houses; // Normalized (0.0 - 1.0)
  final List<ObstacleData> obstacles;

  const LevelData({
    required this.id,
    required this.inkLimit,
    required this.timeLimit,
    required this.startPos,
    required this.houses,
    required this.obstacles,
  });
}

class ObstacleData {
  final Vector2 position; // Normalized (0.0 - 1.0)
  final Vector2
  size; // Absolute size (approximate) or relative? Let's use absolute for consistent gameplay feel, or relative for scaling.
  // Let's use absolute for size to match sprite sizes, but position is relative.
  final ObstacleType type;

  const ObstacleData({
    required this.position,
    required this.size,
    required this.type,
  });
}

class LevelRepository {
  static final List<LevelData> levels = [
    // Level 1: Tutorial - Straight line
    LevelData(
      id: 1,
      inkLimit: 800,
      timeLimit: 30,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.8, 0.5)],
      obstacles: [],
    ),
    // Level 2: One Obstacle
    LevelData(
      id: 2,
      inkLimit: 900,
      timeLimit: 13,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.8, 0.5)],
      obstacles: [
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(80, 200),
          type: ObstacleType.tree,
        ),
      ],
    ),
    // Level 3: Curve - Obstacle blocks the diagonal path
    LevelData(
      id: 3,
      inkLimit: 1000,
      timeLimit: 13,
      startPos: Vector2(0.1, 0.8),
      houses: [Vector2(0.9, 0.2)],
      obstacles: [
        // Large puddle directly on the diagonal path
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(200, 200),
          type: ObstacleType.puddle,
        ),
        // Second obstacle to prevent simple curve
        ObstacleData(
          position: Vector2(0.3, 0.3),
          size: Vector2(100, 100),
          type: ObstacleType.puddle,
        ),
      ],
    ),
    // Level 4: Two Houses - Obstacles force strategic routing
    LevelData(
      id: 4,
      inkLimit: 1400,
      timeLimit: 13,
      startPos: Vector2(0.5, 0.5),
      houses: [Vector2(0.15, 0.15), Vector2(0.85, 0.85)],
      obstacles: [
        // Block direct path to top-left house
        ObstacleData(
          position: Vector2(0.3, 0.3),
          size: Vector2(120, 120),
          type: ObstacleType.tree,
        ),
        // Block direct path to bottom-right house
        ObstacleData(
          position: Vector2(0.7, 0.7),
          size: Vector2(120, 120),
          type: ObstacleType.tree,
        ),
      ],
    ),
    // Level 5: Fence Corridor - Must go through narrow gap
    LevelData(
      id: 5,
      inkLimit: 1000,
      timeLimit: 10,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // Top fence extends down to create narrow gap
        ObstacleData(
          position: Vector2(0.5, 0.15),
          size: Vector2(30, 350),
          type: ObstacleType.fence,
        ),
        // Bottom fence extends up to create narrow gap
        ObstacleData(
          position: Vector2(0.5, 0.85),
          size: Vector2(30, 350),
          type: ObstacleType.fence,
        ),
      ],
    ),
    // Level 6: The Dog - Forces wide detour
    LevelData(
      id: 6,
      inkLimit: 1200,
      timeLimit: 10,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // Large dog blocks the center
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(250, 250),
          type: ObstacleType.dog,
        ),
        // Puddles limit detour options
        ObstacleData(
          position: Vector2(0.5, 0.15),
          size: Vector2(150, 80),
          type: ObstacleType.puddle,
        ),
      ],
    ),
    // Level 7: Zig Zag - True alternating barriers
    LevelData(
      id: 7,
      inkLimit: 1500,
      timeLimit: 10,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // First fence from top - blocks upper path
        ObstacleData(
          position: Vector2(0.33, 0.15),
          size: Vector2(30, 400),
          type: ObstacleType.fence,
        ),
        // Second fence from bottom - blocks lower path
        ObstacleData(
          position: Vector2(0.66, 0.85),
          size: Vector2(30, 400),
          type: ObstacleType.fence,
        ),
      ],
    ),
    // Level 8: Puddle Gauntlet - Navigate through puddle field
    LevelData(
      id: 8,
      inkLimit: 1200,
      timeLimit: 8,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        ObstacleData(
          position: Vector2(0.3, 0.35),
          size: Vector2(130, 130),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.5, 0.65),
          size: Vector2(130, 130),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.7, 0.35),
          size: Vector2(130, 130),
          type: ObstacleType.puddle,
        ),
      ],
    ),
    // Level 9: Around the Block - Obstacles guard each house
    LevelData(
      id: 9,
      inkLimit: 1800,
      timeLimit: 18,
      startPos: Vector2(0.5, 0.5),
      houses: [Vector2(0.15, 0.15), Vector2(0.85, 0.15), Vector2(0.5, 0.85)],
      obstacles: [
        // Fence blocks direct access between top houses
        ObstacleData(
          position: Vector2(0.5, 0.15),
          size: Vector2(300, 40),
          type: ObstacleType.fence,
        ),
        // Trees guard path to bottom house
        ObstacleData(
          position: Vector2(0.35, 0.7),
          size: Vector2(80, 80),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.65, 0.7),
          size: Vector2(80, 80),
          type: ObstacleType.tree,
        ),
      ],
    ),
    // Level 10: Narrow Path - Very tight corridor
    LevelData(
      id: 10,
      inkLimit: 1200,
      timeLimit: 8,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // Top trees create wall
        ObstacleData(
          position: Vector2(0.4, 0.2),
          size: Vector2(80, 400),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.6, 0.2),
          size: Vector2(80, 400),
          type: ObstacleType.tree,
        ),
        // Bottom trees create wall with small gap
        ObstacleData(
          position: Vector2(0.4, 0.8),
          size: Vector2(80, 400),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.6, 0.8),
          size: Vector2(80, 400),
          type: ObstacleType.tree,
        ),
      ],
    ),
    // Level 11: Dog Guard - Dog and obstacles create maze
    LevelData(
      id: 11,
      inkLimit: 1600,
      timeLimit: 8,
      startPos: Vector2(0.1, 0.1),
      houses: [Vector2(0.9, 0.9)],
      obstacles: [
        // Large dog blocks center diagonal
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(220, 220),
          type: ObstacleType.dog,
        ),
        // Puddles block alternate routes
        ObstacleData(
          position: Vector2(0.15, 0.6),
          size: Vector2(120, 120),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.6, 0.15),
          size: Vector2(120, 120),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.85, 0.4),
          size: Vector2(100, 100),
          type: ObstacleType.puddle,
        ),
      ],
    ),
    // Level 12: Maze - True serpentine path required
    LevelData(
      id: 12,
      inkLimit: 1800,
      timeLimit: 8,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // First barrier from top
        ObstacleData(
          position: Vector2(0.28, 0.1),
          size: Vector2(30, 500),
          type: ObstacleType.fence,
        ),
        // Second barrier from bottom
        ObstacleData(
          position: Vector2(0.5, 0.9),
          size: Vector2(30, 500),
          type: ObstacleType.fence,
        ),
        // Third barrier from top
        ObstacleData(
          position: Vector2(0.72, 0.1),
          size: Vector2(30, 500),
          type: ObstacleType.fence,
        ),
      ],
    ),
    // Level 13: Four Corners - Strategic path planning needed
    LevelData(
      id: 13,
      inkLimit: 2500,
      timeLimit: 20,
      startPos: Vector2(0.5, 0.5),
      houses: [
        Vector2(0.1, 0.1),
        Vector2(0.9, 0.1),
        Vector2(0.1, 0.9),
        Vector2(0.9, 0.9),
      ],
      obstacles: [
        // Large center obstacle
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(180, 180),
          type: ObstacleType.dog,
        ),
        // Block diagonal shortcuts
        ObstacleData(
          position: Vector2(0.25, 0.25),
          size: Vector2(100, 100),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.75, 0.25),
          size: Vector2(100, 100),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.25, 0.75),
          size: Vector2(100, 100),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.75, 0.75),
          size: Vector2(100, 100),
          type: ObstacleType.tree,
        ),
      ],
    ),
    // Level 14: Precision - Navigate through puddle maze
    LevelData(
      id: 14,
      inkLimit: 1200,
      timeLimit: 10,
      startPos: Vector2(0.1, 0.5),
      houses: [Vector2(0.9, 0.5)],
      obstacles: [
        // Create a grid of puddles with narrow paths
        ObstacleData(
          position: Vector2(0.35, 0.3),
          size: Vector2(140, 140),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.65, 0.3),
          size: Vector2(140, 140),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.35, 0.7),
          size: Vector2(140, 140),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.65, 0.7),
          size: Vector2(140, 140),
          type: ObstacleType.puddle,
        ),
        // Center puddle forces going around
        ObstacleData(
          position: Vector2(0.5, 0.5),
          size: Vector2(120, 120),
          type: ObstacleType.puddle,
        ),
      ],
    ),
    // Level 15: The Final Delivery - Ultimate challenge
    LevelData(
      id: 15,
      inkLimit: 3000,
      timeLimit: 20,
      startPos: Vector2(0.5, 0.5),
      houses: [Vector2(0.1, 0.1), Vector2(0.9, 0.1), Vector2(0.5, 0.9)],
      obstacles: [
        // Large dog guards the center
        ObstacleData(
          position: Vector2(0.5, 0.35),
          size: Vector2(200, 200),
          type: ObstacleType.dog,
        ),
        // Fences create corridor to bottom house
        ObstacleData(
          position: Vector2(0.25, 0.7),
          size: Vector2(30, 300),
          type: ObstacleType.fence,
        ),
        ObstacleData(
          position: Vector2(0.75, 0.7),
          size: Vector2(30, 300),
          type: ObstacleType.fence,
        ),
        // Puddles near top houses
        ObstacleData(
          position: Vector2(0.25, 0.15),
          size: Vector2(100, 100),
          type: ObstacleType.puddle,
        ),
        ObstacleData(
          position: Vector2(0.75, 0.15),
          size: Vector2(100, 100),
          type: ObstacleType.puddle,
        ),
        // Additional trees to block shortcuts
        ObstacleData(
          position: Vector2(0.15, 0.4),
          size: Vector2(80, 80),
          type: ObstacleType.tree,
        ),
        ObstacleData(
          position: Vector2(0.85, 0.4),
          size: Vector2(80, 80),
          type: ObstacleType.tree,
        ),
      ],
    ),
  ];

  static LevelData getLevel(int id) {
    return levels.firstWhere(
      (level) => level.id == id,
      orElse: () => levels.first,
    );
  }
}
