import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../data/level_data.dart';
import '../data/save_manager.dart';
import 'components/path_component.dart';
import 'managers/audio_manager.dart';
import 'components/bike_component.dart';
import 'components/house_component.dart';
import 'components/obstacle_component.dart';
import 'components/post_office_component.dart';
import 'components/background_component.dart';

enum GameState { planning, delivering, gameOver, levelComplete }

/// The main game class for The Cozy Courier.
/// 
/// This is the entry point for all game logic and manages
/// the game loop, components, and overall game state.
class CozyCourierGame extends FlameGame with PanDetector, DoubleTapDetector, HasCollisionDetection {
  int currentLevelId;
  late LevelData currentLevelData;

  late PathComponent pathComponent;
  late BikeComponent bikeComponent;
  late PostOfficeComponent postOfficeComponent;
  
  // Game State
  GameState gameState = GameState.planning;
  final ValueNotifier<GameState> gameStateNotifier = ValueNotifier(GameState.planning);
  
  // Ink System
  double maxInk = 1500.0;
  double currentInk = 1500.0;
  final ValueNotifier<double> inkNotifier = ValueNotifier(1500.0);
  
  // Timer System
  double maxTime = 30.0;
  double remainingTime = 30.0;
  final ValueNotifier<double> timeNotifier = ValueNotifier(30.0);
  
  // Level Data
  Vector2 startPos = Vector2(100, 200); 
  int totalHouses = 0;
  int deliveredHouses = 0;
  int starsEarned = 0;

  CozyCourierGame({required int levelId}) : currentLevelId = levelId, super();

  @override
  Color backgroundColor() => const Color(0xFFFDFBF7); // Paper Cream

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    currentLevelData = LevelRepository.getLevel(currentLevelId);
    
    AudioManager.playBgm();

    // Add background first (lowest priority)
    add(BackgroundComponent());

    // Add path component so it's under other elements
    pathComponent = PathComponent();
    add(pathComponent);

    resetLevel();
  }

  void resetLevel() {
    // Clear everything first
    removeAll(children.whereType<BikeComponent>());
    removeAll(children.whereType<HouseComponent>());
    removeAll(children.whereType<ObstacleComponent>());
    removeAll(children.whereType<PostOfficeComponent>());
    
    // Reset State
    gameState = GameState.planning;
    gameStateNotifier.value = GameState.planning;
    
    // Load Level Data
    // Scale ink based on screen width (assuming base design is for ~400px width)
    // This ensures gameplay is consistent across different screen sizes
    double screenScale = size.x / 400.0;
    maxInk = currentLevelData.inkLimit * screenScale;
    
    currentInk = maxInk;
    inkNotifier.value = maxInk;
    
    // Reset Timer
    maxTime = currentLevelData.timeLimit;
    remainingTime = maxTime;
    timeNotifier.value = maxTime;
    
    startPos = Vector2(
      currentLevelData.startPos.x * size.x,
      currentLevelData.startPos.y * size.y
    );
    
    deliveredHouses = 0;
    starsEarned = 0;
    pathComponent.clear();
    
    // Rebuild Level
    
    // Add Post Office
    postOfficeComponent = PostOfficeComponent(position: startPos);
    add(postOfficeComponent);

    // Add bike
    bikeComponent = BikeComponent()..position = startPos;
    add(bikeComponent);

    // Add Houses
    totalHouses = currentLevelData.houses.length;
    for (final housePos in currentLevelData.houses) {
      add(HouseComponent(position: Vector2(
        housePos.x * size.x,
        housePos.y * size.y
      )));
    }

    // Add Obstacles
    for (final obstacle in currentLevelData.obstacles) {
      add(ObstacleComponent(
        position: Vector2(
          obstacle.position.x * size.x,
          obstacle.position.y * size.y
        ),
        size: obstacle.size,
        type: obstacle.type,
      ));
    }
    
    // Notify UI
    overlays.remove('GameOver');
    overlays.remove('LevelComplete');
    overlays.add('HUD');
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update timer during planning phase
    if (gameState == GameState.planning) {
      remainingTime -= dt;
      timeNotifier.value = remainingTime;
      
      if (remainingTime <= 0) {
        remainingTime = 0;
        timeNotifier.value = 0;
        onLose("Time's up!");
      }
    }
    
    // Check for win condition if delivering and stopped
    if (gameState == GameState.delivering) {
      // If no effects are running, movement has finished
      if (bikeComponent.children.whereType<Effect>().isEmpty) {
        _checkEndCondition();
      }
    }
  }

  void _checkEndCondition() {
    // Check if returned to start (allow some margin)
    final double distToStart = bikeComponent.position.distanceTo(startPos);
    
    if (distToStart < 50 && deliveredHouses >= totalHouses) {
      _onWin();
    } else {
      onLose("Mission Failed!");
    }
  }
  
  Future<void> _onWin() async {
    AudioManager.playSfx(AudioManager.sfxWin);
    gameState = GameState.levelComplete;
    gameStateNotifier.value = GameState.levelComplete;
    
    // Calculate Stars
    final double percentage = currentInk / maxInk;
    if (percentage > 0.5) {
      starsEarned = 3;
    } else if (percentage > 0.25) {
      starsEarned = 2;
    } else {
      starsEarned = 1;
    }
    
    // Save Progress
    await SaveManager.saveStars(currentLevelId, starsEarned);
    await SaveManager.unlockLevel(currentLevelId + 1);
    
    overlays.add('LevelComplete');
  }

  void loadNextLevel() {
    if (currentLevelId < 15) {
      currentLevelId++;
      currentLevelData = LevelRepository.getLevel(currentLevelId);
      resetLevel();
    }
  }

  void onLose(String message) {
    if (gameState == GameState.gameOver) return; // Already lost
    AudioManager.playSfx(AudioManager.sfxLose);
    gameState = GameState.gameOver;
    gameStateNotifier.value = GameState.gameOver;
    bikeComponent.children.whereType<Effect>().forEach((e) => e.removeFromParent()); // Stop moving
    overlays.add('GameOver');
  }
  
  void onHouseDelivered() {
    if (gameState != GameState.delivering) return;
    deliveredHouses++;
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (gameState != GameState.planning) return;
    
    // Clear existing path and start a new one
    pathComponent.clear();
    currentInk = maxInk;
    inkNotifier.value = maxInk;
    pathComponent.addPoint(info.eventPosition.global);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (gameState != GameState.planning) return;

    if (currentInk <= 0) return; // No ink left

    // Add points to the path if far enough from the last point
    final lastPoint = pathComponent.points.lastOrNull;
    final newPoint = info.eventPosition.global;
    
    if (lastPoint != null) {
      final double dist = newPoint.distanceTo(lastPoint);
      if (dist > 5) { // 5 pixels smoothing threshold
        if (currentInk >= dist) {
          currentInk -= dist;
          inkNotifier.value = currentInk;
          pathComponent.addPoint(newPoint);
        } else {
          // Add partial point? Or just stop. Stop is easier.
          currentInk = 0;
          inkNotifier.value = 0;
        }
      }
    } else {
       pathComponent.addPoint(newPoint);
    }
  }

  @override
  void onDoubleTap() {
    // Erase Path
    if (gameState == GameState.planning) {
       pathComponent.clear();
       currentInk = maxInk;
       inkNotifier.value = maxInk;
    }
  }

  void startDelivery() {
    if (gameState != GameState.planning) return;
    if (pathComponent.points.isEmpty) return;
    
    gameState = GameState.delivering;
    gameStateNotifier.value = GameState.delivering;
    
    final List<Effect> movementEffects = [];
    final double speed = 200.0; // pixels per second

    Vector2 currentPos = bikeComponent.position;
    
    // Create a sequence of moves from point to point
    for (final point in pathComponent.points) {
      final double distance = currentPos.distanceTo(point);
      if (distance > 0.1) { // Ignore tiny movements
        final double time = distance / speed;
        // Linear movement
        movementEffects.add(
          MoveToEffect(
            point, 
            EffectController(duration: time, curve: Curves.linear),
          ),
        );
        currentPos = point;
      }
    }
    
    if (movementEffects.isNotEmpty) {
      bikeComponent.add(SequenceEffect(
        movementEffects,
        onComplete: () {
           // We check condition in update() to catch it exactly when it finishes
           // But checking here is also good as a backup or primary
        }
      ));
    } else {
        // No movement, immediate fail?
        _checkEndCondition();
    }
  }
}
