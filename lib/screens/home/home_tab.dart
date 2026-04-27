import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';
import '../../core/lang_store.dart';
import '../../data/sample_data.dart';
import '../../widgets/car_card.dart';
import 'vip_car_card.dart';
import 'home_brand_strip.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override State<HomeTab> createState() => _HomeState();
}
class _HomeState extends State<HomeTab> {
  String _cat = 'all';
  String _brand = 'All';

  @override void initState() { super.initState(); langNotifier.addListener(_r); }
  @override void dispose()   { langNotifier.removeListener(_r); super.dispose(); }
  void _r() => setState(() {});

  List<Map<String,dynamic>> get _filtered => kCars.where((c) {
    if (_cat == 'new'  && c['cat'] != 'new')  return false;
    if (_cat == 'used' && c['cat'] != 'used') return false;
    if (_brand != 'All' && c['brand'] != _brand) return false;
    return true;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      // ── AppBar ──────────────────────────────────────────────────
      SliverAppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        elevation: 0, pinned: true,
        title: Row(children: [
          Container(width: 32, height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)])),
            child: const Center(child: Icon(Icons.directions_car_rounded, color: Colors.white, size: 18))),
          const SizedBox(width: 8),
          const Text('CarPro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: C.navy)),
        ]),
        actions: [
          Stack(children: [
            IconButton(icon: const Icon(Icons.notifications_outlined, color: C.navy), onPressed: () {}),
            Positioned(right: 8, top: 8, child: Container(width: 8, height: 8,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: C.red))),
          ]),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(52),
          child: Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Container(height: 42,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.border),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Row(children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded, color: C.textSub, size: 20),
                const SizedBox(width: 8),
                Text(T.g('search_hint'), style: const TextStyle(color: Color(0xFFBBC4D8), fontSize: 14)),
                const Spacer(),
                Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(7)),
                  child: const Icon(Icons.tune_rounded, color: C.primary, size: 16)),
              ])))),
      ),
      SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── VIP section header + exchange rate ───────────────────────
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            const Text('VIP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: C.navy, letterSpacing: 0.5)),
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(4)),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 12)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: ThemeManager.active.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(T.g('rate_label').replaceAll('{rate}', AppFlags.usdToIqd.toInt().toString()),
                style: TextStyle(fontSize: 10, color: ThemeManager.active.primary, fontWeight: FontWeight.w600))),
          ])),
        const SizedBox(height: 10),
        // ── VIP cars horizontal strip ────────────────────────────────
        SizedBox(height: 200, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: kCars.where((c) => c['vip'] == true).length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final vipCars = kCars.where((c) => c['vip'] == true).toList();
            return VipCarCard(car: vipCars[i]);
          })),
        const SizedBox(height: 16),
        // ── Watch Reels banner ───────────────────────────────────────
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GestureDetector(
            onTap: () => mainTabNotifier.value = 2,
            child: Container(height: 84, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFFFF3366), Color(0xFF6633FF)]),
              boxShadow: [BoxShadow(color: const Color(0xFFFF3366).withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Stack(children: [
                Positioned(right: -6, top: -6, child: Icon(Icons.play_circle_filled_rounded, size: 110, color: Colors.white.withOpacity(0.13))),
                Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                  Container(width: 48, height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30)),
                  const SizedBox(width: 14),
                  const Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Watch Reels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('Quick video tours of cars for sale', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ])),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ])),
              ])))),
        const SizedBox(height: 14),
        // ── Category chips ───────────────────────────────────────────
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            _CatChip(label: T.g('all_cars'),  val: 'all',  cur: _cat, onTap: () => setState(() => _cat = 'all')),
            const SizedBox(width: 8),
            if (AppFlags.showBrandNew) ...[
              _CatChip(label: T.g('brand_new'), val: 'new', cur: _cat, color: C.green, onTap: () => setState(() => _cat = 'new')),
              const SizedBox(width: 8),
            ],
            if (AppFlags.showUsed)
              _CatChip(label: T.g('used_car'), val: 'used', cur: _cat, color: C.amber, onTap: () => setState(() => _cat = 'used')),
          ])),
        const SizedBox(height: 12),
        // ── Fit-to-screen brand grid + More button ───────────────────
        HomeBrandStrip(selected: _brand, onPicked: (b) => setState(() => _brand = b)),
        const SizedBox(height: 16),
        // ── Featured cars list ───────────────────────────────────────
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(T.g('featured'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
            Text(T.g('see_all'),  style: const TextStyle(fontSize: 13, color: C.primary, fontWeight: FontWeight.w600)),
          ])),
        const SizedBox(height: 10),
        ..._filtered.map((car) => Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: CarCard(car: car, onFav: () => setState(() => car['fav'] = !(car['fav'] as bool))))),
        const SizedBox(height: 10),
      ])),
    ]);
  }
}

class _CatChip extends StatelessWidget {
  final String label, val, cur; final VoidCallback onTap; final Color? color;
  const _CatChip({required this.label, required this.val, required this.cur, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    final col = color ?? C.primary; final sel = val == cur;
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: sel ? col : Colors.white, border: Border.all(color: sel ? col : C.border)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : C.textSub))));
  }
}

// Kept for backward compatibility — not used externally but referenced in old code
class _BrandChip extends StatelessWidget {
  final String label; final bool sel; final VoidCallback onTap;
  const _BrandChip({required this.label, required this.sel, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        color: sel ? C.primary : Colors.white, border: Border.all(color: sel ? C.primary : C.border)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
        color: sel ? Colors.white : C.textSub))));
}
