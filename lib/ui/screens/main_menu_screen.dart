import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/ui/widgets/cozy_button.dart';
import 'package:cozygame/ui/widgets/dialog_panel.dart';
import 'package:cozygame/data/save_manager.dart';
import 'package:cozygame/game/managers/audio_manager.dart';
import 'how_to_play_screen.dart';
import 'privacy_policy_screen.dart';
import 'level_select_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: DialogPanel(
          width: 300,
          child: StatefulBuilder(
            builder: (context, setState) {
              final isMuted = SaveManager.isMuted;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Settings', style: CozyTheme.headingStyle),
                  const SizedBox(height: 24),
                  CozyButton(
                    text: isMuted ? 'SOUND: OFF' : 'SOUND: ON',
                    icon: isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    onPressed: () async {
                      await SaveManager.setMuted(!isMuted);
                      if (!isMuted) {
                        AudioManager.stopBgm();
                      } else {
                        AudioManager.playBgm();
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  CozyButton(
                    text: 'PRIVACY POLICY',
                    icon: Icons.privacy_tip_rounded,
                    type: CozyButtonType.secondary,
                    onPressed: () {
                      Navigator.of(context).pop(); // Close settings first
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CozyButton(
                    text: 'CLOSE',
                    type: CozyButtonType.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ui_logo.png', width: 150),
            const SizedBox(height: 16),
            Text('The Cozy Courier', style: CozyTheme.headingStyle),
            const SizedBox(height: 48),
            
            CozyButton(
              text: 'PLAY',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LevelSelectScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            CozyButton(
              text: 'HOW TO PLAY',
              icon: Icons.help_outline_rounded,
              type: CozyButtonType.secondary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HowToPlayScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            CozyButton(
              text: 'SETTINGS',
              icon: Icons.settings_rounded,
              type: CozyButtonType.secondary,
              onPressed: _showSettings,
            ),
          ],
        ),
      ),
      ),
    );
  }
}

