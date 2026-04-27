import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/helpers.dart';
import '../../core/theme.dart';
import '../../data/brand_data.dart';
import '../car_detail_screen.dart';

/// Horizontal-strip card for VIP cars on the Home tab.
/// Shows brand-color gradient banner with VIP badge, dual-currency price, city.
class VipCarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const VipCarCard({super.key, required this.car});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    final priceText = Cur.primary(car['price'] as double, car['cur']);
    final priceSecText = Cur.secondary(car['price'] as double, car['cur']);
    final brandColor = (kBrandData.firstWhere((b) => b['name'] == car['brand'],
      orElse: () => {'hex': '0D47A1'}))['hex']!;
    final col = Color(int.parse('FF$brandColor', radix: 16));

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailScreen(car: car))),
      child: Container(width: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white,
          boxShadow: [BoxShadow(color: pri.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Visual top with brand-color gradient
          Container(height: 110, decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            gradient: LinearGradient(colors: [col, col.withOpacity(0.6)])),
            child: Stack(children: [
              Center(child: Icon(Icons.directions_car_filled_rounded, size: 70, color: Colors.white.withOpacity(0.25))),
              // VIP badge
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(4)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.star_rounded, color: Colors.white, size: 11),
                  SizedBox(width: 3),
                  Text('VIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                ]))),
              if (car['cat'] == 'new') Positioned(top: 8, right: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: C.green, borderRadius: BorderRadius.circular(4)),
                child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)))),
            ])),
          // Info panel
          Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(car['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 4),
              Text(priceText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: pri)),
              Text(priceSecText, style: const TextStyle(fontSize: 10, color: C.textSub)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 11, color: C.textSub),
                const SizedBox(width: 2),
                Expanded(child: Text(car['city'], style: const TextStyle(fontSize: 10, color: C.textSub),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ])),
        ])));
  }
}

// Backward-compat alias
typedef _VipCarCard = VipCarCard;
