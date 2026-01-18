import 'package:hive_ce/hive.dart';

class SaveManager {
  static const String _boxName = 'cozy_data';
  static const String _keyHighestLevel = 'highestLevel';
  static const String _keyStars = 'levelStars';
  static const String _keyStamps = 'totalStamps';
  static const String _keyMuted = 'isMuted';
  static const String _keyPrivacyAccepted = 'privacyAccepted';

  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static bool get isPrivacyAccepted => _box.get(_keyPrivacyAccepted, defaultValue: false);

  static Future<void> acceptPrivacy() async {
    await _box.put(_keyPrivacyAccepted, true);
  }

  static bool get isMuted => _box.get(_keyMuted, defaultValue: false);

  static Future<void> setMuted(bool muted) async {
    await _box.put(_keyMuted, muted);
  }

  static int get highestLevelUnlocked => _box.get(_keyHighestLevel, defaultValue: 1);

  static Future<void> unlockLevel(int levelId) async {
    if (levelId > highestLevelUnlocked) {
      await _box.put(_keyHighestLevel, levelId);
    }
  }

  static int getStarsForLevel(int levelId) {
    final Map<dynamic, dynamic> starsMap = _box.get(_keyStars, defaultValue: {});
    return starsMap[levelId] ?? 0;
  }

  static Future<void> saveStars(int levelId, int stars) async {
    final Map<dynamic, dynamic> starsMap = Map.from(_box.get(_keyStars, defaultValue: {}));
    final int currentStars = starsMap[levelId] ?? 0;
    
    if (stars > currentStars) {
      starsMap[levelId] = stars;
      await _box.put(_keyStars, starsMap);
      
      // Award stamps for improvement?
      // Plan says: "Award stamps based on star rating... Only award stamps for improvement"
      // If previous was 2, now 3, we gain 1 stamp.
      final int diff = stars - currentStars;
      if (diff > 0) {
        await addStamps(diff);
      }
    }
  }

  static int get totalStamps => _box.get(_keyStamps, defaultValue: 0);

  static Future<void> addStamps(int amount) async {
    final int current = totalStamps;
    await _box.put(_keyStamps, current + amount);
  }

  static Future<void> resetProgress() async {
    await _box.clear();
  }
}

