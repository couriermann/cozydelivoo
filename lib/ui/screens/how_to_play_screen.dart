import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/ui/widgets/cozy_button.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  Widget _buildStep(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: CozyTheme.outlineGrey, width: 2),
            ),
            child: Icon(icon, color: CozyTheme.inkBlue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: CozyTheme.subheadingStyle),
                const SizedBox(height: 4),
                Text(description, style: CozyTheme.bodyStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('How to Play', style: CozyTheme.headingStyle),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CozyTheme.outlineGrey, width: 2),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildStep(
                        'Draw Your Path',
                        'Use your finger to draw a path for the courier. Plan carefully to visit all houses!',
                        Icons.gesture,
                      ),
                      _buildStep(
                        'Watch Your Ink',
                        'You have limited ink! Keep an eye on the ink meter so you don\'t run out halfway.',
                        Icons.opacity,
                      ),
                      _buildStep(
                        'Avoid Obstacles',
                        'Watch out for dogs, puddles, and fences. Hitting them will end your run!',
                        Icons.warning_amber_rounded,
                      ),
                      _buildStep(
                        'Return Home',
                        'After delivering all mail, guide the courier back to the Post Office to complete the level.',
                        Icons.home_filled,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CozyButton(
                text: 'GOT IT!',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
