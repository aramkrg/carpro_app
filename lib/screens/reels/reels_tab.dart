import 'package:flutter/material.dart';
import '../../data/sample_data.dart';
import '../../models/reel.dart';
import 'reel_page.dart';
import 'reels_filter_sheet.dart';

class ReelsTab extends StatefulWidget {
  const ReelsTab({super.key});
  @override State<ReelsTab> createState() => _ReelsState();
}
class _ReelsState extends State<ReelsTab> {
  final _ctrl = PageController();
  // 'all' or 'following'
  String _feed = 'all';
  // Filters
  String? _brandFilter, _modelFilter, _trimFilter;

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  List<Reel> get _filteredReels {
    return kReels.where((r) {
      if (_feed == 'following' && !r.isFollowingSeller) return false;
      if (_brandFilter != null && r.brand != _brandFilter) return false;
      if (_modelFilter != null && r.model != _modelFilter) return false;
      if (_trimFilter  != null && r.trim  != _trimFilter)  return false;
      return true;
    }).toList();
  }

  void _openFilters() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => ReelsFilterSheet(
        brand: _brandFilter, model: _modelFilter, trim: _trimFilter,
        onApply: (b, m, t) => setState(() { _brandFilter = b; _modelFilter = m; _trimFilter = t; })));
  }

  @override
  Widget build(BuildContext context) {
    final reels = _filteredReels;
    return Scaffold(backgroundColor: Colors.black,
      body: Stack(children: [
        // Vertical reel pager
        if (reels.isEmpty) Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.video_library_outlined, color: Colors.white.withOpacity(0.3), size: 56),
          const SizedBox(height: 12),
          Text(_feed == 'following'
              ? 'Follow sellers to see their reels here'
              : 'No reels match your filters',
            style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
          if (_brandFilter != null || _modelFilter != null || _trimFilter != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: () => setState(() { _brandFilter = null; _modelFilter = null; _trimFilter = null; }),
              child: const Text('Clear filters', style: TextStyle(color: Colors.white))),
          ],
        ])) else PageView.builder(
          scrollDirection: Axis.vertical, controller: _ctrl, itemCount: reels.length,
          itemBuilder: (_, i) => ReelPage(reel: reels[i],
            onLikeChanged: () => setState(() {}),
            onFollowChanged: () => setState(() {}))),
        // Top bar — filter button + For You / Following pill toggle
        Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: [
            // Filter button
            GestureDetector(onTap: _openFilters,
              child: Container(width: 38, height: 38,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
                child: Stack(children: [
                  const Center(child: Icon(Icons.tune_rounded, color: Colors.white, size: 20)),
                  if (_brandFilter != null || _modelFilter != null || _trimFilter != null)
                    Positioned(right: 6, top: 6, child: Container(width: 8, height: 8,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber))),
                ]))),
            const Spacer(),
            // All / Following pill toggle
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.4)),
              child: Row(children: [
                _FeedPill(label: 'For You',   val: 'all',       cur: _feed, onTap: () => setState(() => _feed = 'all')),
                _FeedPill(label: 'Following', val: 'following', cur: _feed, onTap: () => setState(() => _feed = 'following')),
              ])),
            const Spacer(),
            const SizedBox(width: 38),
          ])))),
      ]));
  }
}

class _FeedPill extends StatelessWidget {
  final String label, val, cur;
  final VoidCallback onTap;
  const _FeedPill({required this.label, required this.val, required this.cur, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final sel = val == cur;
    return GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          color: sel ? Colors.white : Colors.transparent),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: sel ? Colors.black : Colors.white))));
  }
}
