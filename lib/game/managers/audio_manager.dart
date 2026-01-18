import 'package:flame_audio/flame_audio.dart';
import '../../data/save_manager.dart';

class AudioManager {
  static const String bgmMain = 'bgm_main.mp3';
  static const String sfxBell = 'sfx_bell.mp3';
  static const String sfxButton = 'sfx_button.mp3';
  static const String sfxCrash = 'sfx_crash.mp3';
  static const String sfxDraw = 'sfx_draw.mp3';
  static const String sfxErase = 'sfx_erase.mp3';
  static const String sfxLose = 'sfx_lose.mp3';
  static const String sfxMailDeliver = 'sfx_mail_deliver.mp3';
  static const String sfxStar = 'sfx_star.mp3';
  static const String sfxWin = 'sfx_win.mp3';

  static Future<void> init() async {
    // Preload common sounds
    await FlameAudio.audioCache.loadAll([
      bgmMain, sfxBell, sfxButton, sfxCrash, 
      sfxDraw, sfxErase, sfxLose, sfxMailDeliver, 
      sfxStar, sfxWin
    ]);
  }

  static void playBgm() {
    if (SaveManager.isMuted) return;
    FlameAudio.bgm.play(bgmMain, volume: 0.5);
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }

  static void playSfx(String file, {double volume = 1.0}) {
    if (SaveManager.isMuted) return;
    FlameAudio.play(file, volume: volume);
  }
}

