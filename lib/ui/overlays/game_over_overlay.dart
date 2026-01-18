import 'package:flutter/material.dart';
import '../../game/cozy_courier_game.dart';
import '../widgets/dialog_panel.dart';
import '../widgets/cozy_button.dart';
import '../theme.dart';

class GameOverOverlay extends StatelessWidget {
  final CozyCourierGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: SingleChildScrollView(
          child: DialogPanel(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mission Failed!',
                style: CozyTheme.headingStyle.copyWith(color: CozyTheme.postalRed),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'The mail must be delivered safely.',
                style: CozyTheme.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CozyButton(
                text: 'TRY AGAIN',
                onPressed: () {
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

