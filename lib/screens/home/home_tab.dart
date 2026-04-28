import 'dart:async';
import 'dart:math';
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
  // REQ 7: keyword search
  final _searchCtrl = TextEditingController();
  String _keyword = '';

  @override void initState() {
    super.initState();
    langNotifier.addListener(_r);
    _searchCtrl.addListener(() => setState(() => _keyword = _searchCtrl.text));
  }
  @override void dispose() {
    langNotifier.removeListener(_r);
    _searchCtrl.dispose();
    super.dispose();
  }
  void _r() => setState(() {});

  // REQ 7: smart keyword matching
  bool _matchesKeyword(Map<String, dynamic> c, String kw) {
    if (kw.isEmpty) return true;
    final q = kw.toLowerCase();
    final searchable = [
      c['name'], c['brand'], c['model'], c['city'],
      c['year']?.toString(), c['cat'],
      '${c['price']}',
    ].where((e) => e != null).join(' ').toLowerCase();
    // Match individual words
    final words = q.split(RegExp(r'\s+'));
    return words.every((w) => w.isEmpty || searchable.contains(w));
  }

  List<Map<String,dynamic>> get _filtered => kCars.where((c) {
    if (_cat == 'new'  && c['cat'] != 'new')  return false;
    if (_cat == 'used' && c['cat'] != 'used') return false;
    if (_brand != 'All' && c['brand'] != _brand) return false;
    if (!_matchesKeyword(c, _keyword)) return false;
    return true;
  }).toList();

  List<Map<String,dynamic>> get _vipCars {
    final vips = kCars.where((c) => c['vip'] == true).toList();
    vips.shuffle(Random(DateTime.now().day)); // random but stable per day
    return vips;
  }

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
        // REQ 7: Real functional search bar
        bottom: PreferredSize(preferredSize: const Size.fromHeight(52),
          child: Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Container(height: 42,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _keyword.isNotEmpty ? C.primary : C.border),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Row(children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded, color: C.textSub, size: 20),
                const SizedBox(width: 8),
                Expanded(child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: T.g('search_hint'),
                    hintStyle: const TextStyle(color: Color(0xFFBBC4D8), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 14, color: C.textMain),
                  textInputAction: TextInputAction.search,
                )),
                if (_keyword.isNotEmpty) GestureDetector(
                  onTap: () => _searchCtrl.clear(),
                  child: Container(margin: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.close_rounded, color: C.textSub, size: 18)),
                ) else Container(margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(7)),
                  child: const Icon(Icons.tune_rounded, color: C.primary, size: 16)),
              ])))),
      ),
      SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        // ── VIP section ──────────────────────────────────────────────
        if (_keyword.isEmpty) ...[
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
          // REQ 2: VIP auto-scrolling slideshow
          _VipSlideshow(vipCars: _vipCars),
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
          // REQ 3: Brand strip
          HomeBrandStrip(selected: _brand, onPicked: (b) => setState(() => _brand = b)),
          const SizedBox(height: 16),
        ],
        // ── Featured cars / search results ───────────────────────────
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_keyword.isNotEmpty ? 'Results for "$_keyword"' : T.g('featured'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
            if (_keyword.isNotEmpty)
              Text('${_filtered.length} found', style: const TextStyle(fontSize: 13, color: C.textSub))
            else
              Text(T.g('see_all'), style: const TextStyle(fontSize: 13, color: C.primary, fontWeight: FontWeight.w600)),
          ])),
        const SizedBox(height: 10),
        if (_filtered.isEmpty)
          Padding(padding: const EdgeInsets.all(40),
            child: Column(children: [
              const Icon(Icons.search_off_rounded, size: 48, color: C.textSub),
              const SizedBox(height: 12),
              Text('No cars found for "$_keyword"', style: const TextStyle(color: C.textSub, fontSize: 14), textAlign: TextAlign.center),
            ]))
        else
          ..._filtered.map((car) => Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: CarCard(car: car, onFav: () => setState(() => car['fav'] = !(car['fav'] as bool))))),
        const SizedBox(height: 10),
      ])),
    ]);
  }
}

// ── REQ 2: VIP Slideshow with auto-scroll + swipeable photos ────────
class _VipSlideshow extends StatefulWidget {
  final List<Map<String, dynamic>> vipCars;
  const _VipSlideshow({required this.vipCars});
  @override State<_VipSlideshow> createState() => _VipSlideshowState();
}
class _VipSlideshowState extends State<_VipSlideshow> {
  late PageController _ctrl;
  int _page = 0;
  Timer? _timer;

  @override void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: 0.88);
    if (widget.vipCars.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted || widget.vipCars.isEmpty) return;
        final next = (_page + 1) % widget.vipCars.length;
        _ctrl.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      });
    }
  }
  @override void dispose() { _timer?.cancel(); _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (widget.vipCars.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      SizedBox(height: 210,
        child: PageView.builder(
          controller: _ctrl,
          onPageChanged: (i) => setState(() => _page = i),
          itemCount: widget.vipCars.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: VipCarCard(car: widget.vipCars[i])),
        )),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.vipCars.length, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _page == i ? 18 : 6, height: 6,
          decoration: BoxDecoration(
            color: _page == i ? ThemeManager.active.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3))))),
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
