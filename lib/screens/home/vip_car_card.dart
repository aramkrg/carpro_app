import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../core/theme.dart';
import '../../data/brand_data.dart';
import '../car_detail_screen.dart';

/// VIP car card with swipeable photos + auto slideshow per card.
class VipCarCard extends StatefulWidget {
  final Map<String, dynamic> car;
  const VipCarCard({super.key, required this.car});
  @override State<VipCarCard> createState() => _VipCarCardState();
}
class _VipCarCardState extends State<VipCarCard> {
  int _photoIdx = 0;
  late PageController _photoCtrl;

  @override void initState() { super.initState(); _photoCtrl = PageController(); }
  @override void dispose() { _photoCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    final priceText = Cur.primary(widget.car['price'] as double, widget.car['cur']);
    final priceSecText = Cur.secondary(widget.car['price'] as double, widget.car['cur']);
    final brandColor = (kBrandData.firstWhere((b) => b['name'] == widget.car['brand'],
      orElse: () => {'hex': '0D47A1'}))['hex']!;
    final col = Color(int.parse('FF$brandColor', radix: 16));

    // Get photos — real app uses network images; mock shows brand gradient
    final List<dynamic> photos = widget.car['photos'] as List<dynamic>? ?? [];
    final hasPhotos = photos.isNotEmpty;
    final photoCount = hasPhotos ? photos.length : 1;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CarDetailScreen(car: widget.car))),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white,
          boxShadow: [BoxShadow(color: pri.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── REQ 2: Swipeable photo area ──────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(height: 130,
              child: Stack(children: [
                PageView.builder(
                  controller: _photoCtrl,
                  onPageChanged: (i) => setState(() => _photoIdx = i),
                  itemCount: photoCount,
                  itemBuilder: (_, i) {
                    if (hasPhotos) {
                      return Image.network(photos[i].toString(), fit: BoxFit.cover,
                        width: double.infinity, height: 130,
                        errorBuilder: (_, __, ___) => _brandBg(col));
                    }
                    return _brandBg(col);
                  },
                ),
                // VIP badge
                Positioned(top: 8, left: 8, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(4)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 11),
                    SizedBox(width: 3),
                    Text('VIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                  ]))),
                if (widget.car['cat'] == 'new') Positioned(top: 8, right: 8, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: C.green, borderRadius: BorderRadius.circular(4)),
                  child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)))),
                // Photo counter
                if (photoCount > 1) Positioned(bottom: 8, right: 8, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.photo_library, color: Colors.white, size: 10),
                    const SizedBox(width: 3),
                    Text('${_photoIdx + 1}/$photoCount',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                  ]))),
                // Dot indicators
                if (photoCount > 1) Positioned(bottom: 8, left: 0, right: 0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(photoCount > 5 ? 5 : photoCount, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _photoIdx == i ? 14 : 5, height: 4,
                      decoration: BoxDecoration(
                        color: _photoIdx == i ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(2)))))),
              ])),
          ),
          // Info panel
          Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.car['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 4),
              Text(priceText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: pri)),
              Text(priceSecText, style: const TextStyle(fontSize: 10, color: C.textSub)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 11, color: C.textSub),
                const SizedBox(width: 2),
                Expanded(child: Text(widget.car['city'], style: const TextStyle(fontSize: 10, color: C.textSub),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ])),
        ])),
    );
  }

  Widget _brandBg(Color col) => Container(
    width: double.infinity, height: 130,
    decoration: BoxDecoration(gradient: LinearGradient(colors: [col, col.withOpacity(0.6)])),
    child: Stack(children: [
      Center(child: Icon(Icons.directions_car_filled_rounded, size: 70, color: Colors.white.withOpacity(0.25))),
    ]));
}
