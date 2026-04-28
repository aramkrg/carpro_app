import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../utilities/fullscreen_image_viewer.dart';

class VipCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> vipCars;
  const VipCarousel({super.key, required this.vipCars});

  @override
  State<VipCarousel> createState() => _VipCarouselState();
}

class _VipCarouselState extends State<VipCarousel> {
  late PageController _pageCtrl;
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  late List<Map<String, dynamic>> _shuffled;

  @override
  void initState() {
    super.initState();
    // Shuffle VIP cars randomly on every launch
    _shuffled = List.from(widget.vipCars)..shuffle(Random());
    _pageCtrl = PageController(viewportFraction: 0.88);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _shuffled.isEmpty) return;
      final next = (_currentPage + 1) % _shuffled.length;
      _pageCtrl.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffled.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('VIP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('Featured Cars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _shuffled.length,
            itemBuilder: (_, i) => _VipCarCard(car: _shuffled[i]),
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_shuffled.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i ? ThemeManager.active.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Single VIP car card with swipeable photos ──────────────────────────────
class _VipCarCard extends StatefulWidget {
  final Map<String, dynamic> car;
  const _VipCarCard({required this.car});

  @override
  State<_VipCarCard> createState() => _VipCarCardState();
}

class _VipCarCardState extends State<_VipCarCard> {
  int _photoIndex = 0;
  late PageController _photoCtrl;

  @override
  void initState() {
    super.initState();
    _photoCtrl = PageController();
  }

  @override
  void dispose() {
    _photoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    final List<String> photos = List<String>.from(widget.car['photos'] ?? [widget.car['photo'] ?? '']);
    final car = widget.car;

    return GestureDetector(
      onTap: () {
        // Open car detail
        // Navigator.push(context, MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // ── Photo Swiper ─────────────────────────────────────────
              PageView.builder(
                controller: _photoCtrl,
                onPageChanged: (i) => setState(() => _photoIndex = i),
                itemCount: photos.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => FullscreenImageViewer(photos: photos, initialIndex: i),
                    ));
                  },
                  child: Image.network(
                    photos[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 220,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey)),
                    ),
                  ),
                ),
              ),

              // ── Gradient overlay ─────────────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
              ),

              // ── VIP badge ────────────────────────────────────────────
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade600,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 12),
                      SizedBox(width: 3),
                      Text('VIP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              ),

              // ── Price badge ──────────────────────────────────────────
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${car['price'] ?? '0'}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),

              // ── Photo dot indicators ─────────────────────────────────
              if (photos.length > 1)
                Positioned(
                  top: 14,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(photos.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: _photoIndex == i ? 14 : 6,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _photoIndex == i ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )),
                  ),
                ),

              // ── Car info bottom ──────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car['make'] ?? ''} ${car['model'] ?? ''} ${car['year'] ?? ''}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 12),
                          const SizedBox(width: 4),
                          Text(car['city'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const Spacer(),
                          if (photos.length > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.photo_library, color: Colors.white, size: 12),
                                  const SizedBox(width: 4),
                                  Text('${_photoIndex + 1}/${photos.length}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
