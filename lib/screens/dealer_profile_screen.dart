import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../data/sample_data.dart';
import '../widgets/car_card.dart';

class DealerProfileScreen extends StatefulWidget {
  final Map<String, dynamic> dealer;
  const DealerProfileScreen({super.key, required this.dealer});
  @override State<DealerProfileScreen> createState() => _DealerProfileState();
}
class _DealerProfileState extends State<DealerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    final dealer = widget.dealer;
    final dealerCars = kCars.take(6).toList(); // mock — real = filter by dealerId

    return Scaffold(
      backgroundColor: C.bg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: C.navy,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                // Cover photo
                Container(height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [theme.primary, theme.primaryDk]),
                  ),
                  child: dealer['coverPhoto'] != null
                    ? Image.network(dealer['coverPhoto'], fit: BoxFit.cover, width: double.infinity)
                    : Center(child: Icon(Icons.storefront_rounded, size: 60, color: Colors.white.withOpacity(0.3)))),
                // Logo + verified badge
                Positioned(bottom: 0, left: 20,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)]),
                    child: dealer['logo'] != null
                      ? ClipOval(child: Image.network(dealer['logo'], fit: BoxFit.cover))
                      : Center(child: Icon(Icons.storefront_rounded, color: theme.primary, size: 36))),
                ),
                Positioned(bottom: 4, left: 80,
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.green.shade500, borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                      SizedBox(width: 3),
                      Text('Verified Dealer', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ]))),
              ]),
            ),
          ),
          // Dealer info below cover
          SliverToBoxAdapter(child: Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(dealer['name'] ?? 'Dealership', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: C.navy)),
                  const SizedBox(height: 2),
                  Text(dealer['slogan'] ?? 'Quality Cars for Every Budget',
                    style: const TextStyle(fontSize: 12, color: C.textSub)),
                ])),
                // Follow button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: ThemeManager.active.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 12),
              // Stats row
              Row(children: [
                _StatPill(icon: Icons.directions_car_rounded, label: '${dealerCars.length}+ Cars'),
                const SizedBox(width: 8),
                _StatPill(icon: Icons.star_rounded, label: '4.8 Rating', color: C.gold),
                const SizedBox(width: 8),
                _StatPill(icon: Icons.people_rounded, label: '2.3k Followers'),
              ]),
              const SizedBox(height: 12),
              // Contact info
              _InfoRow(Icons.location_on_outlined, dealer['address'] ?? 'Baghdad, Iraq'),
              const SizedBox(height: 6),
              _InfoRow(Icons.phone_rounded, dealer['phone'] ?? '+964 750 000 0000'),
              const SizedBox(height: 6),
              _InfoRow(Icons.email_rounded, dealer['email'] ?? 'info@dealership.iq'),
              const SizedBox(height: 6),
              if (dealer['website'] != null)
                _InfoRow(Icons.language_rounded, dealer['website']),
              const SizedBox(height: 12),
              // Action buttons
              Row(children: [
                Expanded(child: _ActionBtn(icon: Icons.call_rounded, label: 'Call',
                  color: Colors.green.shade600, onTap: () {})),
                const SizedBox(width: 8),
                Expanded(child: _ActionBtn(icon: Icons.chat_rounded, label: 'WhatsApp',
                  color: const Color(0xFF25D366), onTap: () {})),
                const SizedBox(width: 8),
                Expanded(child: _ActionBtn(icon: Icons.share_rounded, label: 'Share',
                  color: ThemeManager.active.primary, onTap: () {})),
              ]),
            ]))),
          // Tabs
          SliverPersistentHeader(pinned: true,
            delegate: _TabBarDelegate(TabBar(
              controller: _tabCtrl,
              labelColor: ThemeManager.active.primary,
              unselectedLabelColor: C.textSub,
              indicatorColor: ThemeManager.active.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [Tab(text: 'Cars'), Tab(text: 'Reels'), Tab(text: 'About')],
            ))),
        ],
        body: TabBarView(controller: _tabCtrl, children: [
          // ── Cars grid ───────────────────────────────────────────
          GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.78, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: dealerCars.length,
            itemBuilder: (_, i) => _DealerCarCard(car: dealerCars[i])),
          // ── Reels ─────────────────────────────────────────────
          GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.56, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: 9,
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
              child: Stack(children: [
                Center(child: Icon(Icons.play_circle_fill_rounded, color: Colors.white.withOpacity(0.7), size: 32)),
                Positioned(bottom: 6, left: 6, child: Text('${12 + i}k views',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
              ]))),
          // ── About ────────────────────────────────────────────
          ListView(padding: const EdgeInsets.all(20), children: [
            const Text('About Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.navy)),
            const SizedBox(height: 10),
            Text(dealer['about'] ?? 'We are a trusted car dealership with over 10 years of experience. We offer a wide range of new and used vehicles, competitive pricing, and excellent customer service.',
              style: const TextStyle(fontSize: 14, color: C.textSub, height: 1.6)),
            const SizedBox(height: 20),
            const Text('Working Hours', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: C.navy)),
            const SizedBox(height: 10),
            _InfoRow(Icons.schedule_rounded, 'Saturday - Thursday: 9am - 8pm'),
            const SizedBox(height: 6),
            _InfoRow(Icons.schedule_rounded, 'Friday: 2pm - 8pm'),
          ]),
        ]),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon; final String label; final Color? color;
  const _StatPill({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: C.border)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: color ?? C.primary),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.textSub)),
    ]));
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 15, color: C.textSub),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: C.textSub))),
  ]);
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ])));
}

class _DealerCarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  const _DealerCarCard({required this.car});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(height: 100, color: Colors.grey.shade200,
          child: Center(child: Icon(Icons.directions_car_filled_rounded,
            size: 50, color: Colors.grey.shade400)))),
      Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(car['name'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.navy)),
        const SizedBox(height: 3),
        Text('\$${car['price']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: ThemeManager.active.primary)),
        Text(car['city'] ?? '', style: const TextStyle(fontSize: 10, color: C.textSub)),
      ])),
    ]));
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);
  @override double get minExtent => tabBar.preferredSize.height + 1;
  @override double get maxExtent => tabBar.preferredSize.height + 1;
  @override Widget build(_, __, ___) => Container(color: Colors.white,
    child: Column(children: [tabBar, const Divider(height: 1, color: C.border)]));
  @override bool shouldRebuild(_) => false;
}
