import 'package:flutter/material.dart';
import '../../game/cozy_courier_game.dart';
import '../widgets/ink_meter.dart';
import '../widgets/cozy_button.dart';

class HudOverlay extends StatelessWidget {
  final CozyCourierGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Ink Meter (Left)
            Align(
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder<double>(
                valueListenable: game.inkNotifier,
                builder: (context, ink, _) {
                  return InkMeter(currentInk: ink, maxInk: game.maxInk);
                },
              ),
            ),

            // Timer (Top Center) - Only in planning
            Align(
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<GameState>(
                valueListenable: game.gameStateNotifier,
                builder: (context, state, _) {
                  if (state != GameState.planning) {
                    return const SizedBox.shrink();
                  }

                  return ValueListenableBuilder<double>(
                    valueListenable: game.timeNotifier,
                    builder: (context, time, _) {
                      final int seconds = time.ceil();
                      final bool isLow = seconds <= 5;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isLow ? const Color(0xFFFF6B6B) : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: isLow
                                ? const Color(0xFFCC5555)
                                : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              color: isLow
                                  ? Colors.white
                                  : const Color(0xFF5D4E37),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$seconds',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isLow
                                    ? Colors.white
                                    : const Color(0xFF5D4E37),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Pause Button (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: CozyButton(
                text: 'PAUSE',
                icon: Icons.pause_rounded,
                type: CozyButtonType.secondary,
                onPressed: () {
                  game.overlays.add('Pause');
                  game.pauseEngine();
                },
              ),
            ),

            // Deliver Button (Bottom Right) - Only in planning
            Align(
              alignment: Alignment.bottomRight,
              child: ValueListenableBuilder<GameState>(
                valueListenable: game.gameStateNotifier,
                builder: (context, state, _) {
                  if (state != GameState.planning) {
                    return const SizedBox.shrink();
                  }

                  return CozyButton(
                    text: 'DELIVER!',
                    icon: Icons.send_rounded,
                    type: CozyButtonType.primary,
                    onPressed: () {
                      game.startDelivery();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
