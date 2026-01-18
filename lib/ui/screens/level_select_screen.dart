import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/data/save_manager.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: CozyTheme.inkBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Select Level', style: CozyTheme.headingStyle),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: ValueNotifier(SaveManager.highestLevelUnlocked), // This needs to be reactive if possible, but for now we just read on build
        builder: (context, highestLevel, _) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.8,
            ),
            itemCount: 15,
            itemBuilder: (context, index) {
              final level = index + 1;
              final isUnlocked = level <= SaveManager.highestLevelUnlocked;
              final stars = SaveManager.getStarsForLevel(level);

              return GestureDetector(
                onTap: isUnlocked ? () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GameScreen(levelId: level)),
                  );
                  // Refresh state when coming back from game
                  setState(() {});
                } : null,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            isUnlocked 
                              ? (stars == 3 
                                  ? 'assets/images/ui_mailbox_complete.png' 
                                  : 'assets/images/ui_mailbox_unlocked.png')
                              : 'assets/images/ui_mailbox_locked.png',
                            fit: BoxFit.contain,
                            opacity: isUnlocked ? const AlwaysStoppedAnimation(1) : const AlwaysStoppedAnimation(0.5),
                          ),
                          if (isUnlocked && stars > 0 && stars < 3)
                             Positioned(
                               bottom: 0,
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: List.generate(stars, (index) => 
                                   const Icon(Icons.star_rounded, color: Colors.amber, size: 20)
                                 ),
                               ),
                             ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level $level',
                      style: CozyTheme.captionStyle,
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}

