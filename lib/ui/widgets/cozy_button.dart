import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/game/managers/audio_manager.dart';

enum CozyButtonType { primary, secondary }

class CozyButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final CozyButtonType type;
  final IconData? icon;

  const CozyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = CozyButtonType.primary,
    this.icon,
  });

  @override
  State<CozyButton> createState() => _CozyButtonState();
}

class _CozyButtonState extends State<CozyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    AudioManager.playSfx(AudioManager.sfxButton);
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.type == CozyButtonType.primary;

    final backgroundColor = isPrimary ? CozyTheme.postalRed : Colors.white;
    final borderColor = isPrimary ? Colors.white : CozyTheme.outlineGrey;
    final borderWidth = isPrimary ? 3.0 : 2.0;
    
    // Shadow offset changes on press
    final double shadowOffset = _isPressed ? 0 : (isPrimary ? 4.0 : 2.0);
    final Color shadowColor = isPrimary ? CozyTheme.inkBlue : Colors.black.withValues(alpha: 0.1);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(0, shadowOffset),
                blurRadius: 0, // Hard shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: CozyTheme.inkBlue),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.text.toUpperCase(),
                  style: CozyTheme.buttonTextStyle.copyWith(
                    color: CozyTheme.inkBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

