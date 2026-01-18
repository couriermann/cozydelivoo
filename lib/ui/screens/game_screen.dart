import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../game/cozy_courier_game.dart';
import '../overlays/hud_overlay.dart';
import '../overlays/pause_overlay.dart';
import '../overlays/game_over_overlay.dart';
import '../overlays/level_complete_overlay.dart';

class GameScreen extends StatelessWidget {
  final int levelId;

  const GameScreen({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold provides SafeArea context
      body: GameWidget<CozyCourierGame>(
        game: CozyCourierGame(levelId: levelId),
        overlayBuilderMap: {
          'HUD': (context, game) => HudOverlay(game: game),
          'Pause': (context, game) => PauseOverlay(game: game),
          'GameOver': (context, game) => GameOverOverlay(game: game),
          'LevelComplete': (context, game) => LevelCompleteOverlay(game: game),
        },
        initialActiveOverlays: const ['HUD'],
      ),
    );
  }
}

