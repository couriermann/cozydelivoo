import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/ui/widgets/cozy_button.dart';
import 'package:cozygame/data/save_manager.dart';
import 'main_menu_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Privacy Notice',
                style: CozyTheme.headingStyle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: CozyTheme.outlineGrey, width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      'We value your privacy. This game saves your progress locally on your device.\n\n'
                      'We do not collect any personal data, location data, or usage statistics.\n\n'
                      'By tapping "Accept", you agree to play The Cozy Courier and have fun!',
                      style: CozyTheme.bodyStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CozyButton(
                text: 'ACCEPT',
                onPressed: () async {
                  await SaveManager.acceptPrivacy();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

