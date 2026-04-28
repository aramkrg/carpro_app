import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/brand_data.dart';
import '../../widgets/brand_logo.dart';

/// REQ 3: Home brand strip
/// - "All" button fixed at LEFT
/// - Brand logos scrollable horizontally in the middle
/// - "More" button fixed at RIGHT
/// - 1 tap = select, 2nd tap = unselect (toggle)
class HomeBrandStrip extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onPicked;
  const HomeBrandStrip({super.key, required this.selected, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;

    return SizedBox(height: 80,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // ── "All" fixed at left ────────────────────────────────────
        Padding(padding: const EdgeInsets.only(left: 14, right: 6),
          child: GestureDetector(
            onTap: () => onPicked('All'),
            child: SizedBox(width: 52, child: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedContainer(duration: const Duration(milliseconds: 180),
                width: 46, height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected == 'All' ? pri : Colors.white,
                  border: Border.all(color: selected == 'All' ? pri : C.border, width: 2),
                  boxShadow: selected == 'All' ? [BoxShadow(color: pri.withOpacity(0.3), blurRadius: 8)] : null,
                ),
                child: Center(child: Text('ALL', style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w900,
                  color: selected == 'All' ? Colors.white : C.textSub)))),
              const SizedBox(height: 5),
              Text('All', style: TextStyle(fontSize: 10,
                fontWeight: selected == 'All' ? FontWeight.w700 : FontWeight.w500,
                color: selected == 'All' ? pri : C.textSub)),
            ]))),
        ),

        // ── Scrollable brand logos ─────────────────────────────────
        Expanded(child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: kBrands.length,
          separatorBuilder: (_, __) => const SizedBox(width: 4),
          itemBuilder: (_, i) {
            final b = kBrands[i];
            final s = selected == b;
            return GestureDetector(
              // REQ 3: toggle — 1st tap = select, 2nd tap = unselect → go to All
              onTap: () => onPicked(s ? 'All' : b),
              child: SizedBox(width: 54, child: Column(mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: s ? pri : Colors.transparent, width: 2.5),
                      boxShadow: s ? [BoxShadow(color: pri.withOpacity(0.25), blurRadius: 6)] : null),
                    child: Padding(padding: const EdgeInsets.all(2),
                      child: BrandLogo(name: b, size: 44))),
                  const SizedBox(height: 5),
                  Text(b, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10,
                      fontWeight: s ? FontWeight.w700 : FontWeight.w500,
                      color: s ? pri : C.textSub)),
              ])));
          },
        )),

        // ── "More" fixed at right ──────────────────────────────────
        Padding(padding: const EdgeInsets.only(left: 6, right: 14),
          child: GestureDetector(
            onTap: () async {
              final r = await showModalBottomSheet<String>(context: context, isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => const BrandLogoSheet());
              if (r != null) onPicked(r);
            },
            child: SizedBox(width: 54, child: Column(mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 46, height: 46,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: pri.withOpacity(0.1),
                    border: Border.all(color: pri.withOpacity(0.25), width: 1.5)),
                  child: Icon(Icons.grid_view_rounded, color: pri, size: 22)),
                const SizedBox(height: 5),
                Text('More', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: pri)),
              ])),
          )),
      ]),
    );
  }
}

typedef _HomeBrandStrip = HomeBrandStrip;
