import 'package:flutter/material.dart';
import '../core/translations.dart';
import '../core/app_flags.dart';
import '../widgets/shared_widgets.dart';
import 'language_screen.dart';
import 'phone_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashState();
}
class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ring, _fade, _scale;
  @override
  void initState() {
    super.initState();
    _ring  = AnimationController(duration: const Duration(seconds: 6), vsync: this)..repeat();
    _fade  = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..forward();
    _scale = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..forward();
  }
  @override void dispose() { _ring.dispose(); _fade.dispose(); _scale.dispose(); super.dispose(); }

  void _go(Widget page) => Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));

  void _browseGuest() => _go(const MainShell());

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF060B18),
      body: Stack(children: [
        // Background gradient
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF060B18)]))),
        // Spinning neon ring
        Center(child: AnimatedBuilder(
          animation: _ring,
          builder: (_, __) => Transform.rotate(
            angle: _ring.value * 2 * 3.14159,
            child: CustomPaint(size: Size(sz.width * 0.78, sz.width * 0.78), painter: _NeonRing())))),
        // Content
        FadeTransition(opacity: _fade,
          child: SafeArea(child: Column(children: [
            SizedBox(height: sz.height * 0.08),
            // REQ 11: CarPro logo image
            ScaleTransition(
              scale: CurvedAnimation(parent: _scale, curve: Curves.elasticOut),
              child: Container(
                width: sz.width * 0.55,
                height: sz.width * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF1E88E5).withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                  ],
                ),
                // Try to load the asset logo; falls back to the App logo ball
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/carpro_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                      // Fallback if asset not added yet
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)])),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.directions_car_filled_rounded, color: Colors.white, size: 50),
                          const SizedBox(height: 6),
                          const Text('CarPro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 2)),
                        ])),
                  )),
              )),
            const SizedBox(height: 20),
            const Text('CarPro', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3)),
            const SizedBox(height: 6),
            Text(T.g('tagline'), style: const TextStyle(fontSize: 14, color: Colors.white60, letterSpacing: 0.5)),
            const Spacer(),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Column(children: [
              PriBtn(label: T.g('get_started'), onTap: () => _go(const LanguageScreen())),
              const SizedBox(height: 12),
              OutlineWhiteBtn(label: T.g('login'), onTap: () => _go(const PhoneScreen())),
              const SizedBox(height: 12),
              // REQ 10: Guest browse option
              if (AppFlags.guestBrowsing)
                GestureDetector(onTap: _browseGuest,
                  child: const Text('Browse as Guest →',
                    style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500))),
              SizedBox(height: sz.height * 0.05),
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
