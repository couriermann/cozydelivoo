import 'package:flutter/material.dart';
import '../../game/cozy_courier_game.dart';
import '../widgets/dialog_panel.dart';
import '../widgets/cozy_button.dart';
import '../theme.dart';

class PauseOverlay extends StatelessWidget {
  final CozyCourierGame game;

  const PauseOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5), // Dim background
      child: Center(
        child: SingleChildScrollView(
          child: DialogPanel(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PAUSED',
                style: CozyTheme.headingStyle,
              ),
              const SizedBox(height: 32),
              CozyButton(
                text: 'RESUME',
                onPressed: () {
                  game.overlays.remove('Pause');
                  game.resumeEngine();
                },
              ),
              const SizedBox(height: 16),
              CozyButton(
                text: 'RESTART',
                type: CozyButtonType.secondary,
                onPressed: () {
                  game.resetLevel();
                  game.overlays.remove('Pause');
                  game.resumeEngine();
                },
              ),
              const SizedBox(height: 16),
              CozyButton(
                text: 'EXIT',
                type: CozyButtonType.secondary,
                onPressed: () {
                  game.resumeEngine();
                  // Assuming GameScreen was pushed
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

