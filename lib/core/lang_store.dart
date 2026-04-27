import 'package:flutter/foundation.dart';
import 'translations.dart';

// ═══════════════════════════════════════════════════════════════════
// LANGUAGE PERSISTENCE (uses SharedPreferences in production)
// ═══════════════════════════════════════════════════════════════════
class LangStore {
  static String? _saved;
  static bool _firstLaunch = true;
  static bool get isFirstLaunch => _firstLaunch;
  static String? get saved => _saved;
  static void save(String lang) { _saved = lang; _firstLaunch = false; }
  // In production: SharedPreferences.getInstance().then((p) {
  //   p.setString('lang', lang); p.setBool('first', false); });
  static void load() {
    // In production: read SharedPreferences and set _saved and _firstLaunch
  }
}

// ═══════════════════════════════════════════════════════════════════
// GLOBAL NOTIFIERS
// ═══════════════════════════════════════════════════════════════════

/// Rebuilds entire app when language changes.
final langNotifier = ValueNotifier<String>('en');

/// Add Car wizard step (0..4). Hoisted so MainShell's PopScope can
/// decrement it when hardware/browser back is pressed.
final addCarStepNotifier = ValueNotifier<int>(0);

/// Allows any screen to switch the active main tab.
/// 0=Home  1=Search  2=Reels  3=AddCar  4=Messages  5=Profile
final mainTabNotifier = ValueNotifier<int>(0);

void setLanguage(String l) {
  T.set(l);
  LangStore.save(l);
  langNotifier.value = l;
}
