import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/helpers.dart';
// CarDetailScreen is in screens — import resolved by barrel via car_detail_screen.dart
// We use a forward import pattern: car_card.dart imports car_detail_screen.dart.
// This is intentional — CarCard navigates to CarDetailScreen on tap.
import '../screens/car_detail_screen.dart';

/// Horizontal list card for a single car.
/// Used in Home feed, Search results, Favorites, and My Listings.
class CarCard extends StatelessWidget {
  final Map<String,dynamic> car; final VoidCallback onFav;
  const CarCard({super.key, required this.car, required this.onFav});

  @override
  Widget build(BuildContext context) {
    final isNew = car['cat'] == 'new';
    final pri = Cur.primary(car['price'] as double, car['cur']);
    final sec = Cur.secondary(car['price'] as double, car['cur']);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailScreen(car: car))),
      child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Row(children: [
          Stack(children: [
            Container(width: 120, height: 96, decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              gradient: LinearGradient(colors: [C.primaryDk.withOpacity(0.9), C.navy])),
              child: const Center(child: Icon(Icons.directions_car_filled_rounded, color: Colors.white24, size: 44))),
            if (car['vip'] == true) Positioned(top: 6, left: 6,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(5)),
                child: Text(T.g('vip'), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)))),
            if (isNew) Positioned(bottom: 6, left: 6,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: C.green, borderRadius: BorderRadius.circular(5)),
                child: Text(T.g('new_lbl'), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)))),
          ]),
          Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(car['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy), maxLines: 1, overflow: TextOverflow.ellipsis)),
                GestureDetector(onTap: onFav, child: Icon(car['fav'] ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: car['fav'] ? C.red : C.textSub, size: 20)),
              ]),
              const SizedBox(height: 2),
              Text(pri, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.primary)),
              Text(sec, style: const TextStyle(fontSize: 11, color: C.textSub)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 11, color: C.textSub),
                Text(car['city'], style: const TextStyle(fontSize: 11, color: C.textSub)),
                const SizedBox(width: 8),
                if (!isNew) ...[
                  const Icon(Icons.speed_outlined, size: 11, color: C.textSub),
                  Text(_fmt(car['km'] as int), style: const TextStyle(fontSize: 11, color: C.textSub)),
                  Text(' ${T.g('km')}', style: const TextStyle(fontSize: 11, color: C.textSub)),
                ],
              ]),
            ]))),
        ]),
      ),
    );
  }
  static String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
}

// Private alias for backward compatibility
typedef _CarCard = CarCard;
