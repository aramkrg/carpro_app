import 'app_flags.dart';

// ═══════════════════════════════════════════════════════════════════
// YEAR HELPER — auto calculates max year, never needs manual update
// In 2026 → max is 2027. In 2027 → max is 2028. Always current+1.
// ═══════════════════════════════════════════════════════════════════
class YearHelper {
  static int get currentYear => DateTime.now().year;
  static int get maxYear => currentYear + 1;
  static List<String> get allYears =>
      List.generate(maxYear - 1900 + 1, (i) => (maxYear - i).toString());
}

// ═══════════════════════════════════════════════════════════════════
// CURRENCY HELPER
// ═══════════════════════════════════════════════════════════════════
class Cur {
  static String _commas(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  static String fmtUsd(double v) => '\$${_commas(v.toInt())}';
  static String fmtIqd(double v) => '${_commas(v.toInt())} IQD';
  static String toIqdStr(double usd) => fmtIqd(usd * AppFlags.usdToIqd);
  static String toUsdStr(double iqd) => fmtUsd(iqd / AppFlags.usdToIqd);
  static String primary(double a, String cur) =>
      cur == 'USD' ? fmtUsd(a) : fmtIqd(a);
  static String secondary(double a, String cur) =>
      cur == 'USD' ? '≈ ${toIqdStr(a)}' : '≈ ${toUsdStr(a)}';
}
