import 'package:flutter/material.dart';
import '../../core/auth.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../data/sample_data.dart';
import '../../widgets/car_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override State<FavoritesScreen> createState() => _FavState();
}
class _FavState extends State<FavoritesScreen> {
  @override void initState() { super.initState(); authNotifier.addListener(_r); }
  @override void dispose()   { authNotifier.removeListener(_r); super.dispose(); }
  void _r() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.current;
    final favs = user == null
      ? <Map<String, dynamic>>[]
      : kCars.where((c) => user.favoriteCarIds.contains(c['id'])).toList();
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('favorites'),
            style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: favs.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.favorite_outline_rounded, size: 64, color: C.textSub.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Text('No saved cars yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.navy)),
              const SizedBox(height: 4),
              const Text('Tap the heart icon on any car to save it here',
                style: TextStyle(fontSize: 13, color: C.textSub), textAlign: TextAlign.center),
            ]))
          : ListView.separated(padding: const EdgeInsets.all(14), itemCount: favs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => CarCard(car: favs[i], onFav: () {
                AuthService.toggleFavorite(favs[i]['id'] as String);
                setState(() {});
              }))));
  }
}
