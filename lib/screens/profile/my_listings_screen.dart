import 'package:flutter/material.dart';
import '../../core/auth.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../data/sample_data.dart';
import '../../widgets/car_card.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = AuthService.current;
    final myCars = user == null
      ? <Map<String, dynamic>>[]
      : kCars.where((c) => user.myListingIds.contains(c['id'])).toList();
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('my_listings'),
            style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: myCars.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.directions_car_outlined, size: 64, color: C.textSub.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Text('No listings yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.navy)),
              const SizedBox(height: 4),
              const Text('Post your first car from the Add tab',
                style: TextStyle(fontSize: 13, color: C.textSub)),
            ]))
          : ListView.separated(padding: const EdgeInsets.all(14), itemCount: myCars.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => CarCard(car: myCars[i], onFav: () {})),
      ));
  }
}
