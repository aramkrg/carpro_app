import 'package:flutter/material.dart';
import '../../core/auth.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../widgets/login_wall.dart';
import 'dealer_profile_screen.dart';

// ── Mock dealer data (replace with API in production) ────────────────────────
final List<Map<String, dynamic>> kDealers = [
  {
    'id': 'd1',
    'name': 'Al-Rasheed Motors',
    'slogan': 'Quality Cars Since 2010',
    'city': 'Baghdad',
    'phone': '+964 750 155 2108',
    'email': 'info@rasheedmotors.iq',
    'address': 'Baghdad, Karrada District',
    'website': 'www.rasheedmotors.iq',
    'about': 'We are a trusted dealership with 300+ cars in stock. Specializing in Toyota, Kia, and Hyundai.',
    'carsCount': 87,
    'rating': 4.8,
    'followers': 2300,
    'coverGradient': [0xFF1565C0, 0xFF0D47A1],
    'logoIcon': Icons.storefront_rounded,
    'verified': true,
    'since': '2010',
  },
  {
    'id': 'd2',
    'name': 'Kurdistan Auto Gallery',
    'slogan': 'Premium & Luxury Cars',
    'city': 'Erbil',
    'phone': '+964 770 200 3000',
    'email': 'sales@kag.iq',
    'address': 'Erbil, 60 Meter Road',
    'about': 'Exclusive dealer for Mercedes-Benz, BMW and Lexus in the Kurdistan region.',
    'carsCount': 54,
    'rating': 4.9,
    'followers': 5100,
    'coverGradient': [0xFF37474F, 0xFF263238],
    'logoIcon': Icons.directions_car_filled_rounded,
    'verified': true,
    'since': '2015',
  },
  {
    'id': 'd3',
    'name': 'Sulaymaniyah Motors',
    'slogan': 'Best Prices in Town',
    'city': 'Sulaymaniyah',
    'phone': '+964 770 333 4444',
    'email': 'contact@sulaymaniyahmotors.iq',
    'address': 'Sulaymaniyah, Bakhtiyari',
    'about': 'Family-owned dealership serving Sulaymaniyah since 2008.',
    'carsCount': 120,
    'rating': 4.6,
    'followers': 1800,
    'coverGradient': [0xFF1B5E20, 0xFF2E7D32],
    'logoIcon': Icons.car_repair_rounded,
    'verified': true,
    'since': '2008',
  },
  {
    'id': 'd4',
    'name': 'Basra Elite Cars',
    'slogan': 'Southern Iraq\'s #1 Dealer',
    'city': 'Basra',
    'phone': '+964 780 100 5555',
    'email': 'elite@basracars.iq',
    'address': 'Basra, Ashar District',
    'about': 'Specializing in new and certified used cars for the southern region.',
    'carsCount': 64,
    'rating': 4.5,
    'followers': 920,
    'coverGradient': [0xFF4A148C, 0xFF6A1B9A],
    'logoIcon': Icons.emoji_transportation_rounded,
    'verified': false,
    'since': '2018',
  },
  {
    'id': 'd5',
    'name': 'Duhok Auto Center',
    'slogan': 'Trusted for 15 Years',
    'city': 'Duhok',
    'phone': '+964 750 600 7777',
    'email': 'info@duhokauto.iq',
    'address': 'Duhok, City Center',
    'about': 'Wide selection of Japanese and Korean cars at competitive prices.',
    'carsCount': 43,
    'rating': 4.7,
    'followers': 1100,
    'coverGradient': [0xFFBF360C, 0xFFE64A19],
    'logoIcon': Icons.local_car_wash_rounded,
    'verified': true,
    'since': '2009',
  },
  {
    'id': 'd6',
    'name': 'Kirkuk Motors Hub',
    'slogan': 'Drive Your Dream Car',
    'city': 'Kirkuk',
    'phone': '+964 770 800 9999',
    'email': 'hub@kirkukmotors.iq',
    'address': 'Kirkuk, Corniche Road',
    'about': 'Over 200 cars in stock, financing available for all buyers.',
    'carsCount': 210,
    'rating': 4.4,
    'followers': 3200,
    'coverGradient': [0xFF006064, 0xFF00838F],
    'logoIcon': Icons.two_wheeler_rounded,
    'verified': true,
    'since': '2012',
  },
];

class DealersDirectoryScreen extends StatefulWidget {
  const DealersDirectoryScreen({super.key});
  @override State<DealersDirectoryScreen> createState() => _DealersDirectoryState();
}

class _DealersDirectoryState extends State<DealersDirectoryScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCity = 'All';

  final List<String> _cities = ['All', 'Baghdad', 'Erbil', 'Sulaymaniyah', 'Duhok', 'Kirkuk', 'Basra', 'Mosul'];

  @override void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _searchQuery = _searchCtrl.text));
  }
  @override void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<Map<String, dynamic>> get _filtered => kDealers.where((d) {
    final q = _searchQuery.toLowerCase();
    if (_selectedCity != 'All' && d['city'] != _selectedCity) return false;
    if (q.isNotEmpty) {
      final searchable = '${d['name']} ${d['city']} ${d['slogan']}'.toLowerCase();
      return searchable.contains(q);
    }
    return true;
  }).toList();

  void _openDealer(Map<String, dynamic> dealer) {
    // REQ: only members can view dealer profile
    requireLogin(context, () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DealerProfileScreen(dealer: dealer)));
    }, reason: 'Sign in to view dealer profiles and contact them');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: const Text('Verified Dealers', style: TextStyle(fontWeight: FontWeight.w800, color: C.navy)),
        backgroundColor: Colors.white,
        foregroundColor: C.navy,
        elevation: 0,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade300)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified_rounded, size: 14, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text('${kDealers.where((d) => d['verified'] == true).length} Verified',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green.shade700)),
              ]))),
        ],
      ),
      body: Column(children: [
        // ── Search + City filter ─────────────────────────────────────
        Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Column(children: [
            // Search bar
            Container(height: 42,
              decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _searchQuery.isNotEmpty ? theme.primary : C.border)),
              child: Row(children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded, color: C.textSub, size: 20),
                const SizedBox(width: 8),
                Expanded(child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Search dealers by name or city...',
                    hintStyle: TextStyle(color: Color(0xFFBBC4D8), fontSize: 13),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                  style: const TextStyle(fontSize: 13, color: C.textMain))),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(onTap: () => _searchCtrl.clear(),
                    child: const Padding(padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.close_rounded, color: C.textSub, size: 18))),
              ])),
            const SizedBox(height: 10),
            // City filter chips
            SizedBox(height: 32, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _cities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final city = _cities[i];
                final sel = _selectedCity == city;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCity = city),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? theme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: sel ? theme.primary : C.border)),
                    child: Text(city, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : C.textSub))));
              })),
          ])),

        // ── Guest banner ─────────────────────────────────────────────
        if (!AuthService.isLoggedIn)
          Container(margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.primary.withOpacity(0.08), theme.primary.withOpacity(0.03)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.primary.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.lock_outline_rounded, color: theme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('Sign in to contact dealers and view full profiles',
                style: TextStyle(fontSize: 12, color: theme.primary, fontWeight: FontWeight.w500))),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PhoneScreenImport())),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: theme.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)))),
            ])),

        // ── Dealer count ─────────────────────────────────────────────
        Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_filtered.length} Dealers', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy)),
            Text(_selectedCity == 'All' ? 'All Cities' : _selectedCity,
              style: TextStyle(fontSize: 12, color: theme.primary, fontWeight: FontWeight.w600)),
          ])),

        // ── Dealer grid ──────────────────────────────────────────────
        Expanded(child: _filtered.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.storefront_outlined, size: 48, color: C.textSub),
              const SizedBox(height: 12),
              Text('No dealers found', style: const TextStyle(color: C.textSub, fontSize: 15)),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.82,
                crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _DealerCard(dealer: _filtered[i], onTap: () => _openDealer(_filtered[i])))),
      ]),
    );
  }
}

// ── Individual dealer card ─────────────────────────────────────────────────
class _DealerCard extends StatelessWidget {
  final Map<String, dynamic> dealer;
  final VoidCallback onTap;
  const _DealerCard({required this.dealer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradColors = (dealer['coverGradient'] as List<dynamic>)
      .map((c) => Color(c as int)).toList();
    final isVerified = dealer['verified'] == true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Cover photo ────────────────────────────────────────────
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(children: [
              Container(height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradColors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Stack(children: [
                  // Background pattern
                  Positioned(right: -10, bottom: -10,
                    child: Icon(dealer['logoIcon'] as IconData, size: 80,
                      color: Colors.white.withOpacity(0.12))),
                  // Logo circle
                  Center(child: Container(width: 52, height: 52,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 2)),
                    child: Icon(dealer['logoIcon'] as IconData, color: Colors.white, size: 28))),
                ])),
              // Verified badge
              if (isVerified) Positioned(top: 8, right: 8,
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(20)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.verified_rounded, color: Colors.white, size: 10),
                    SizedBox(width: 2),
                    Text('Verified', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                  ]))),
              // Lock overlay for guests
              if (!AuthService.isLoggedIn) Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.15)),
                  child: const Center(child: Icon(Icons.lock_rounded, color: Colors.white70, size: 20)))),
            ])),
          // ── Info ────────────────────────────────────────────────────
          Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(dealer['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 2),
              Text(dealer['slogan'], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: C.textSub)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 11, color: C.textSub),
                const SizedBox(width: 2),
                Text(dealer['city'], style: const TextStyle(fontSize: 10, color: C.textSub)),
                const Spacer(),
                Icon(Icons.star_rounded, size: 11, color: Colors.amber.shade600),
                const SizedBox(width: 2),
                Text('${dealer['rating']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: C.textMain)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.directions_car_rounded, size: 11, color: ThemeManager.active.primary),
                const SizedBox(width: 3),
                Text('${dealer['carsCount']} Cars',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ThemeManager.active.primary)),
              ]),
            ])),
        ])),
    );
  }
}

// Import helper — avoids circular dep
class PhoneScreenImport extends StatelessWidget {
  const PhoneScreenImport({super.key});
  @override
  Widget build(BuildContext context) {
    // This navigates to phone screen via pushReplacement to avoid issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/phone');
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
