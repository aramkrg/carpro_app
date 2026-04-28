import 'package:flutter/material.dart';
import '../../core/auth.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../data/brand_data.dart';
import '../../data/sample_data.dart';
import '../../models/reel.dart';
import '../../widgets/brand_logo.dart';
import '../../widgets/login_wall.dart';
import '../car_detail_screen.dart';
import '../messages/chat_screen.dart';

/// Single-reel page (one item in the vertical PageView).
/// UI mockup — Phase 1 swaps the gradient + icon background for a real
/// video player using the video_player package.
class ReelPage extends StatefulWidget {
  final Reel reel;
  final VoidCallback onLikeChanged, onFollowChanged;
  const ReelPage({super.key, required this.reel, required this.onLikeChanged, required this.onFollowChanged});
  @override State<ReelPage> createState() => _ReelPageState();
}
class _ReelPageState extends State<ReelPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  bool _heartFlash = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
  }
  @override void dispose() { _pulse.dispose(); super.dispose(); }

  void _onDoubleTap() {
    if (!widget.reel.isLiked) widget.reel.isLiked = true;
    setState(() => _heartFlash = true);
    Future.delayed(const Duration(milliseconds: 700), () { if (mounted) setState(() => _heartFlash = false); });
    widget.onLikeChanged();
  }

  void _toggleLike() {
    setState(() => widget.reel.isLiked = !widget.reel.isLiked);
    widget.onLikeChanged();
  }

  void _toggleFollow() {
    if (!AuthService.isLoggedIn) {
      requireLogin(context, () {
        setState(() => widget.reel.isFollowingSeller = !widget.reel.isFollowingSeller);
        widget.onFollowChanged();
      }, reason: 'Sign in to follow sellers');
      return;
    }
    setState(() => widget.reel.isFollowingSeller = !widget.reel.isFollowingSeller);
    widget.onFollowChanged();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reel;
    final brandColor = (kBrandData.firstWhere((b) => b['name'] == r.brand,
      orElse: () => {'hex': '0D47A1'}))['hex']!;
    final col = Color(int.parse('FF$brandColor', radix: 16));
    final priceText = Cur.primary(r.price, r.currency);
    final priceSecText = Cur.secondary(r.price, r.currency);

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(children: [
        // Background — placeholder gradient (Phase 1: real video)
        Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [col, col.withOpacity(0.6), Colors.black]))),
        // Big car icon as the "video" content
        Center(child: Icon(Icons.directions_car_filled_rounded, size: 200, color: Colors.white.withOpacity(0.15))),
        // Pulsing play indicator (Phase 1: replaced by real video player)
        Center(child: AnimatedBuilder(animation: _pulse,
          builder: (_, _) => Container(
            width: 70 + _pulse.value * 14,
            height: 70 + _pulse.value * 14,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1 + _pulse.value * 0.08)),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40)))),
        // Heart-flash on double-tap
        if (_heartFlash) Center(child: Icon(Icons.favorite_rounded, size: 110, color: C.red.withOpacity(0.85))),
        // Bottom-left info card
        Positioned(left: 16, right: 90, bottom: 30,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Text('@${r.sellerName}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white,
                  shadows: [Shadow(blurRadius: 4)])),
              if (r.sellerVerified) ...[
                const SizedBox(width: 5),
                const Icon(Icons.verified_rounded, color: Color(0xFF42A5F5), size: 16),
              ],
            ]),
            const SizedBox(height: 6),
            Text('${r.year} ${r.brand} ${r.model}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white,
                shadows: [Shadow(blurRadius: 6)])),
            Text(r.trim, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85))),
            const SizedBox(height: 8),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.2)),
                child: Text(priceText,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white))),
              const SizedBox(width: 8),
              Text(priceSecText, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
            ]),
            const SizedBox(height: 10),
            // View Details button (opens regular CarDetailScreen)
            GestureDetector(
              onTap: () {
                final car = kCars.firstWhere((c) => c['id'] == r.carId, orElse: () => kCars.first);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)));
              },
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)]),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.black),
                ]))),
          ])),
        // Right-side action column — follow / like / chat / share / views
        Positioned(right: 12, bottom: 30,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Seller avatar with follow button overlay
            Stack(clipBehavior: Clip.none, children: [
              Container(width: 50, height: 50,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: ClipOval(child: BrandLogo(name: r.brand, size: 46))),
              Positioned(bottom: -6, left: 13, child: GestureDetector(onTap: _toggleFollow,
                child: Container(width: 22, height: 22,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: r.isFollowingSeller ? Colors.green : C.red),
                  child: Icon(r.isFollowingSeller ? Icons.check_rounded : Icons.add_rounded,
                    color: Colors.white, size: 14)))),
            ]),
            const SizedBox(height: 22),
            _ReelAction(icon: r.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              label: _shortNum(r.likeCount + (r.isLiked ? 1 : 0)),
              color: r.isLiked ? C.red : Colors.white, onTap: _toggleLike),
            const SizedBox(height: 16),
            _ReelAction(icon: Icons.chat_bubble_outline_rounded, label: 'Chat',
              color: Colors.white, onTap: () => requireLogin(context, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(name: r.sellerName)));
              }, reason: 'Sign in to message the seller')),
            const SizedBox(height: 16),
            _ReelAction(icon: Icons.share_outlined, label: 'Share',
              color: Colors.white, onTap: () {}),
            const SizedBox(height: 16),
            _ReelAction(icon: Icons.visibility_outlined, label: _shortNum(r.viewCount),
              color: Colors.white70, onTap: null),
          ])),
      ]));
  }

  static String _shortNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000)    return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _ReelAction extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback? onTap;
  const _ReelAction({required this.icon, required this.label, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Column(children: [
      Icon(icon, color: color, size: 30, shadows: const [Shadow(blurRadius: 6, color: Colors.black54)]),
      const SizedBox(height: 3),
      Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700,
        shadows: const [Shadow(blurRadius: 4, color: Colors.black87)])),
    ]));
}

// Backward-compat alias
typedef _ReelPage = ReelPage;
