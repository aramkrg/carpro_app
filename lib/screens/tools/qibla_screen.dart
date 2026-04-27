import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';
import '../../widgets/shared_widgets.dart';

/// Qibla Compass.
/// Real heading sensor wires up in Phase 1 with `flutter_compass` package.
/// For now: input city, calculate bearing to Mecca (21.4225°N, 39.8262°E)
/// using the great-circle formula, show static compass.
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});
  @override State<QiblaScreen> createState() => _QiblaState();
}
class _QiblaState extends State<QiblaScreen> {
  // Pre-computed bearings for major Iraqi cities. In Phase 1 we'll
  // get the user's GPS coords automatically and compute live.
  static const _cities = <String, (double, double)>{
    'Erbil':        (36.1911, 44.0094),
    'Baghdad':      (33.3152, 44.3661),
    'Sulaymaniyah': (35.5610, 45.4408),
    'Duhok':        (36.8669, 42.9503),
    'Basra':        (30.5085, 47.7804),
    'Mosul':        (36.3489, 43.1577),
    'Kirkuk':       (35.4681, 44.3922),
    'Najaf':        (32.0000, 44.3333),
    'Karbala':      (32.6160, 44.0244),
  };
  static const _meccaLat = 21.4225;
  static const _meccaLng = 39.8262;

  String _city = 'Erbil';

  /// Great-circle initial bearing from city to Mecca, in degrees from north.
  double get _bearing {
    final (lat1, lng1) = _cities[_city]!;
    final f1 = _toRad(lat1), f2 = _toRad(_meccaLat);
    final dl = _toRad(_meccaLng - lng1);
    final y = _sin(dl) * _cos(f2);
    final x = _cos(f1) * _sin(f2) - _sin(f1) * _cos(f2) * _cos(dl);
    var deg = _toDeg(_atan2(y, x));
    return (deg + 360) % 360;
  }

  // Math helpers — Dart has these in dart:math but using inline keeps
  // imports simple; for Phase 1 we'll switch to dart:math.
  double _toRad(double d) => d * 3.141592653589793 / 180;
  double _toDeg(double r) => r * 180 / 3.141592653589793;
  double _sin(double x) {
    // Taylor series approx — accurate enough for compass bearing
    x = x % (2 * 3.141592653589793);
    double s = x, t = x;
    for (int i = 1; i <= 8; i++) { t *= -x * x / ((2 * i) * (2 * i + 1)); s += t; }
    return s;
  }
  double _cos(double x) => _sin(x + 3.141592653589793 / 2);
  double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.141592653589793;
    if (x < 0 && y < 0)  return _atan(y / x) - 3.141592653589793;
    if (x == 0 && y > 0) return 3.141592653589793 / 2;
    if (x == 0 && y < 0) return -3.141592653589793 / 2;
    return 0;
  }
  double _atan(double x) {
    if (x.abs() <= 1) {
      double s = x, t = x;
      for (int i = 1; i <= 12; i++) { t *= -x * x; s += t / (2 * i + 1); }
      return s;
    }
    return (x > 0 ? 1 : -1) * (3.141592653589793 / 2 - _atan(1 / x));
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    final bearing = _bearing;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Qibla Compass',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text(
                'Live compass requires device sensor (Phase 1). For now, select your city to see bearing toward Mecca.',
                style: TextStyle(fontSize: 12, color: Color(0xFF7B5800)))),
            ])),
          const SizedBox(height: 14),
          const Text('Your city',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.textMain)),
          const SizedBox(height: 6),
          FDrop(val: _city, items: _cities.keys.toList(),
            onChanged: (v) { if (v != null) setState(() => _city = v); }),
          const SizedBox(height: 24),
          // Compass dial
          AspectRatio(aspectRatio: 1, child: Stack(alignment: Alignment.center, children: [
            // Outer ring
            Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
              boxShadow: [BoxShadow(color: pri.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8))],
              border: Border.all(color: pri.withOpacity(0.2), width: 2))),
            // Cardinal direction labels
            const Align(alignment: Alignment(0, -0.85),
              child: Text('N', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: C.red))),
            const Align(alignment: Alignment(0.85, 0),
              child: Text('E', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.textSub))),
            const Align(alignment: Alignment(0, 0.85),
              child: Text('S', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.textSub))),
            const Align(alignment: Alignment(-0.85, 0),
              child: Text('W', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.textSub))),
            // Qibla arrow
            Transform.rotate(angle: bearing * 3.141592653589793 / 180,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 30),
                Icon(Icons.location_on_rounded, color: pri, size: 56),
                const SizedBox(height: 4),
                Container(width: 4, height: 80,
                  decoration: BoxDecoration(color: pri, borderRadius: BorderRadius.circular(2))),
              ])),
            // Center dot
            Container(width: 16, height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: pri,
                boxShadow: [BoxShadow(color: pri.withOpacity(0.4), blurRadius: 8)])),
          ])),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Column(children: [
              const Text('Direction toward Mecca',
                style: TextStyle(fontSize: 13, color: C.textSub)),
              const SizedBox(height: 4),
              Text('${bearing.toStringAsFixed(1)}°',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: pri)),
              const SizedBox(height: 4),
              Text('From $_city', style: const TextStyle(fontSize: 12, color: C.textSub)),
            ])),
        ])));
  }
}
