import 'package:flutter/material.dart';
import '../core/translations.dart';
import '../widgets/shared_widgets.dart';
import 'language_screen.dart';
import 'phone_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashState();
}
class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ring, _fade;
  @override
  void initState() {
    super.initState();
    _ring = AnimationController(duration: const Duration(seconds: 5), vsync: this)..repeat();
    _fade = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)..forward();
  }
  @override void dispose() { _ring.dispose(); _fade.dispose(); super.dispose(); }

  void _go(Widget page) => Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (_, _, _) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, a, _, c) => FadeTransition(opacity: a, child: c)));

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF060B18),
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF060B18)]))),
        Center(child: AnimatedBuilder(
          animation: _ring,
          builder: (_, _) => Transform.rotate(
            angle: _ring.value * 2 * 3.14159,
            child: CustomPaint(size: Size(sz.width * 0.78, sz.width * 0.78), painter: _NeonRing())))),
        FadeTransition(opacity: _fade, child: SafeArea(child: Column(children: [
          SizedBox(height: sz.height * 0.1),
          AppLogoBall(sz: 90, dark: true),
          const SizedBox(height: 16),
          const Text('CarPro', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
          const SizedBox(height: 6),
          Text(T.g('tagline'), style: const TextStyle(fontSize: 14, color: Colors.white60, letterSpacing: 0.5)),
          Expanded(child: Center(child: Icon(Icons.directions_car_filled_rounded,
            size: sz.width * 0.52, color: Colors.white.withOpacity(0.07)))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Column(children: [
            PriBtn(label: T.g('get_started'), onTap: () => _go(const LanguageScreen())),
            const SizedBox(height: 12),
            OutlineWhiteBtn(label: T.g('login'), onTap: () => _go(const PhoneScreen())),
            SizedBox(height: sz.height * 0.06),
          ])),
        ]))),
      ]),
    );
  }
}

class _NeonRing extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 8;
    final cols = [
      const Color(0xFFFF3366), const Color(0xFFFF6633), const Color(0xFFFFCC33),
      const Color(0xFF66FF33), const Color(0xFF33FFCC), const Color(0xFF33AAFF),
      const Color(0xFF6633FF), const Color(0xFFCC33FF), const Color(0xFFFF33AA),
      const Color(0xFFFF3366),
    ];
    final g = SweepGradient(colors: cols);
    final rect = Rect.fromCircle(center: c, radius: r);
    canvas.drawCircle(c, r, Paint()
      ..style = PaintingStyle.stroke ..strokeWidth = 8
      ..shader = g.createShader(rect));
    canvas.drawCircle(c, r - 16, Paint()
      ..style = PaintingStyle.stroke ..strokeWidth = 2
      ..shader = g.createShader(Rect.fromCircle(center: c, radius: r - 16))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
  }
  @override bool shouldRepaint(_) => true;
}
