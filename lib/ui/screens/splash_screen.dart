import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/game/managers/audio_manager.dart';
import 'package:cozygame/data/save_manager.dart';
import 'main_menu_screen.dart';
import 'privacy_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.wait([
      AudioManager.init(),
      SaveManager.init(),
    ]);
    
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          final nextScreen = SaveManager.isPrivacyAccepted 
              ? const MainMenuScreen() 
              : const PrivacyScreen();
              
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ui_logo.png', width: 200),
            const SizedBox(height: 24),
            Text(
              'The Cozy Courier',
              style: CozyTheme.headingStyle,
            ),
          ],
        ),
      ),
    );
  }
}

