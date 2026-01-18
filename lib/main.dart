import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Set preferred orientations for the game
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Set fullscreen mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const CozyCourierApp());
}

class CozyCourierApp extends StatelessWidget {
  const CozyCourierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Cozy Courier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B7355)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
