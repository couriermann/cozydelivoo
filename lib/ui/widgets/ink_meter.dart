import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';

class InkMeter extends StatelessWidget {
  final double currentInk;
  final double maxInk;

  const InkMeter({
    super.key,
    required this.currentInk,
    required this.maxInk,
  });

  @override
  Widget build(BuildContext context) {
    // Percentage 0.0 to 1.0
    final double percentage = (currentInk / maxInk).clamp(0.0, 1.0);

    return Container(
      width: 40,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CozyTheme.outlineGrey, width: 2),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Liquid fill
          FractionallySizedBox(
            heightFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: CozyTheme.skyBlue,
                borderRadius: BorderRadius.circular(18), // Slightly less than container
              ),
            ),
          ),
          // Icon or Label (Optional, maybe just the liquid)
          Positioned(
            bottom: 8,
            child: Icon(Icons.water_drop, color: Colors.white.withValues(alpha: 0.5), size: 20),
          ),
        ],
      ),
    );
  }
}

