import 'package:flutter/material.dart';
import 'app_flags.dart';

// ═══════════════════════════════════════════════════════════════════
// GLASS THEMES — User-pickable + admin-controlled + event-triggered
// ═══════════════════════════════════════════════════════════════════
class AppTheme {
  final String id, name;
  final Color primary, primaryDk, primaryLt, accent, navy, bg;
  final IconData icon;
  final bool isDark;
  const AppTheme({
    required this.id, required this.name,
    required this.primary, required this.primaryDk, required this.primaryLt,
    required this.accent, required this.navy, required this.bg,
    required this.icon, this.isDark = false,
  });
}

/// All available themes.
/// USER themes = admin-allowed list user can pick from in Profile → Theme.
/// EVENT themes = auto-applied during their date ranges, override user pick.
class Themes {
  // ── User-pickable ────────────────────────────────────────────────
  static const oceanBlue = AppTheme(
    id: 'ocean_blue', name: 'Ocean Blue',
    primary: Color(0xFF1565C0), primaryDk: Color(0xFF0D47A1), primaryLt: Color(0xFF1E88E5),
    accent: Color(0xFF42A5F5), navy: Color(0xFF0A1F5C), bg: Color(0xFFF5F7FA),
    icon: Icons.water_drop_outlined,
  );
  static const oledBlack = AppTheme(
    id: 'oled_black', name: 'OLED Black',
    primary: Color(0xFF42A5F5), primaryDk: Color(0xFF1E88E5), primaryLt: Color(0xFF64B5F6),
    accent: Color(0xFF90CAF9), navy: Color(0xFFE3F2FD), bg: Color(0xFF000000),
    icon: Icons.dark_mode_outlined, isDark: true,
  );
  static const sunsetOrange = AppTheme(
    id: 'sunset_orange', name: 'Sunset Orange',
    primary: Color(0xFFEF6C00), primaryDk: Color(0xFFE65100), primaryLt: Color(0xFFFB8C00),
    accent: Color(0xFFFFA726), navy: Color(0xFF3E2723), bg: Color(0xFFFFF8E1),
    icon: Icons.wb_sunny_outlined,
  );
  static const emeraldGreen = AppTheme(
    id: 'emerald_green', name: 'Emerald Green',
    primary: Color(0xFF00897B), primaryDk: Color(0xFF00695C), primaryLt: Color(0xFF26A69A),
    accent: Color(0xFF4DB6AC), navy: Color(0xFF004D40), bg: Color(0xFFE0F2F1),
    icon: Icons.eco_outlined,
  );
  static const roseGold = AppTheme(
    id: 'rose_gold', name: 'Rose Gold',
    primary: Color(0xFFC2185B), primaryDk: Color(0xFFAD1457), primaryLt: Color(0xFFE91E63),
    accent: Color(0xFFEC407A), navy: Color(0xFF560027), bg: Color(0xFFFCE4EC),
    icon: Icons.favorite_outline,
  );
  static const royalPurple = AppTheme(
    id: 'royal_purple', name: 'Royal Purple',
    primary: Color(0xFF6A1B9A), primaryDk: Color(0xFF4A148C), primaryLt: Color(0xFF7B1FA2),
    accent: Color(0xFF9C27B0), navy: Color(0xFF311B92), bg: Color(0xFFF3E5F5),
    icon: Icons.auto_awesome_outlined,
  );

  // ── Event themes (auto-applied on specific dates) ────────────────
  static const nawroz = AppTheme(
    id: 'nawroz', name: 'Nawroz Festival',
    primary: Color(0xFFD32F2F), primaryDk: Color(0xFFB71C1C), primaryLt: Color(0xFFE57373),
    accent: Color(0xFFFFB300), navy: Color(0xFF3E2723), bg: Color(0xFFFFEBEE),
    icon: Icons.local_fire_department_outlined,
  );
  static const eid = AppTheme(
    id: 'eid', name: 'Eid Mubarak',
    primary: Color(0xFF2E7D32), primaryDk: Color(0xFF1B5E20), primaryLt: Color(0xFF388E3C),
    accent: Color(0xFFFFD700), navy: Color(0xFF1B5E20), bg: Color(0xFFE8F5E9),
    icon: Icons.brightness_high_outlined,
  );
  static const newYear = AppTheme(
    id: 'new_year', name: 'New Year',
    primary: Color(0xFFFFB300), primaryDk: Color(0xFFFF8F00), primaryLt: Color(0xFFFFC107),
    accent: Color(0xFFFFE082), navy: Color(0xFF3E2723), bg: Color(0xFFFFF8E1),
    icon: Icons.celebration_outlined,
  );

  /// Themes user can choose from (controlled by admin via AppFlags.allowedThemeIds).
  static List<AppTheme> get user => [oceanBlue, oledBlack, sunsetOrange, emeraldGreen, roseGold, royalPurple];

  /// Event themes (auto-applied during their date ranges, override user pick).
  static List<AppTheme> get events => [nawroz, eid, newYear];

  static AppTheme? byId(String id) {
    final all = [...user, ...events];
    for (final t in all) if (t.id == id) return t;
    return null;
  }
}

/// An event window: when active, its theme overrides the user's pick.
/// In production these dates come from Firebase Remote Config (admin-editable).
class EventWindow {
  final AppTheme theme;
  final DateTime start, end;
  const EventWindow({required this.theme, required this.start, required this.end});
}

class ThemeManager {
  static AppTheme _active = Themes.oceanBlue;
  static String? _userPickId;
  static AppTheme get active => _active;
  static String? get userPickId => _userPickId;

  /// Default schedule. Admin can override these dates from the panel
  /// (each year these auto-recompute against the current year).
  static List<EventWindow> get scheduledEvents {
    final y = DateTime.now().year;
    return [
      EventWindow(theme: Themes.nawroz,  start: DateTime(y, 3, 18),   end: DateTime(y, 3, 26)),
      EventWindow(theme: Themes.eid,     start: DateTime(y, 4, 8),    end: DateTime(y, 4, 14)),
      EventWindow(theme: Themes.eid,     start: DateTime(y, 6, 14),   end: DateTime(y, 6, 20)),
      EventWindow(theme: Themes.newYear, start: DateTime(y, 12, 28),  end: DateTime(y + 1, 1, 5)),
    ];
  }

  /// Currently active event theme, or null if no event window is open today.
  static AppTheme? activeEventTheme() {
    if (!AppFlags.eventThemesEnabled) return null;
    final now = DateTime.now();
    for (final ev in scheduledEvents) {
      if (now.isAfter(ev.start) && now.isBefore(ev.end)) return ev.theme;
    }
    return null;
  }

  static void setUserPick(String id) {
    _userPickId = id;
    // In production: SharedPreferences.getInstance().then((p) => p.setString('theme', id));
    _refresh();
  }

  /// Re-evaluate active theme. Event > user pick > default.
  static void _refresh() {
    final eventOverride = activeEventTheme();
    if (eventOverride != null) {
      _active = eventOverride;
    } else if (_userPickId != null) {
      _active = Themes.byId(_userPickId!) ?? Themes.oceanBlue;
    } else {
      _active = Themes.oceanBlue;
    }
    themeNotifier.value = _active;
  }

  static void load() {
    // In production: read from SharedPreferences and call setUserPick if found
    _refresh();
  }
}

final themeNotifier = ValueNotifier<AppTheme>(Themes.oceanBlue);
