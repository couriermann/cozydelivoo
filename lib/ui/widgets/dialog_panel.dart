import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';

class DialogPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const DialogPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CozyTheme.paperCream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

