// ═══════════════════════════════════════════════════════════════════
// ADMIN FEATURE FLAGS
// In production these are fetched from Firebase Remote Config.
// Every single feature can be turned ON/OFF by admin without app update.
// ═══════════════════════════════════════════════════════════════════
class AppFlags {
  // ── Category visibility ──────────────────────────────────────────
  static bool showBrandNew    = true;
  static bool showUsed        = true;
  // ── Contact buttons ──────────────────────────────────────────────
  static bool callButton      = true;
  static bool whatsappButton  = true;
  static bool viberButton     = true;
  static bool chatEnabled     = true;
  // ── Listing features ─────────────────────────────────────────────
  static bool damagePainter   = true;
  static bool videoUpload     = true;
  static bool photo360        = true;
  static bool voiceNote       = true;
  static bool autoTranslate   = true;
  static bool installments    = true;
  static bool vipListings     = true;
  static bool reportButton    = true;
  static bool blockButton     = true;
  // ── Auth & access ────────────────────────────────────────────────
  static bool guestBrowsing   = true;
  static bool biometricLogin  = true;
  static bool paymentRequired = true;
  // ── Profile settings ─────────────────────────────────────────────
  static bool darkModeOption  = true;
  static bool dataSaverOption = true;
  // ── Other features ───────────────────────────────────────────────
  static bool gamesEnabled    = true;
  static bool historyReport   = true;
  static bool carServices     = true;
  // ── Exchange rate (admin sets manually) ──────────────────────────
  static double usdToIqd      = 1310.0;   // 1 USD = 1310 IQD
  // ── Listing lifecycle ────────────────────────────────────────────
  static int listingFeeIqd    = 10000;
  static int listingDays      = 90;
  // ── Theme system ─────────────────────────────────────────────────
  // Admin master switch for user theme selection
  static bool themesEnabled       = true;
  // Restrict which themes users can pick. Empty list = all user themes allowed.
  // Example: ['ocean_blue','oled_black','emerald_green']
  static List<String> allowedThemeIds = [];
  // Auto-apply event themes on Nawroz / Eid / New Year ranges
  static bool eventThemesEnabled  = true;
}
