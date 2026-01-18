import 'package:flutter/material.dart';
import '../../game/cozy_courier_game.dart';
import '../widgets/dialog_panel.dart';
import '../widgets/cozy_button.dart';
import '../theme.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final CozyCourierGame game;

  const LevelCompleteOverlay({super.key, required this.game});

  Widget _buildStar(bool filled, {bool isCenter = false}) {
    final double size = isCenter ? 64 : 48;
    return Image.asset(
      filled ? 'assets/images/ui_star_filled.png' : 'assets/images/ui_star_empty.png',
      width: size,
      height: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: SingleChildScrollView(
          child: DialogPanel(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Level Complete!',
                style: CozyTheme.headingStyle.copyWith(color: CozyTheme.meadowGreen),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(game.starsEarned >= 1),
                  const SizedBox(width: 8),
                  _buildStar(game.starsEarned >= 2, isCenter: true),
                  const SizedBox(width: 8),
                  _buildStar(game.starsEarned >= 3),
                ],
              ),
              const SizedBox(height: 32),
              if (game.currentLevelId < 15)
                CozyButton(
                  text: 'NEXT LEVEL',
                  onPressed: () {
                    game.overlays.remove('LevelComplete');
                    game.loadNextLevel();
                  },
                ),
              const SizedBox(height: 16),
              CozyButton(
                text: 'REPLAY',
                type: CozyButtonType.secondary,
                onPressed: () {
                  game.overlays.remove('LevelComplete');
                  game.resetLevel();
                },
              ),
              const SizedBox(height: 16),
              CozyButton(
                text: 'EXIT',
                type: CozyButtonType.secondary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

