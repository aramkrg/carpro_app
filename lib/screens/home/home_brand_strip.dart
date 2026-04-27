import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/brand_data.dart';
import '../../widgets/brand_logo.dart';

/// Home tab brand strip — fits screen width.
/// Calculates how many brand circles fit, shows the most popular ones,
/// reserves the rightmost slot for a "More" button that opens the full
/// brand picker grid sheet.
class HomeBrandStrip extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onPicked;
  const HomeBrandStrip({super.key, required this.selected, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, cons) {
      // Each brand circle slot is ~58px wide (logo 46 + 2 padding either side
      // for the selection ring + ~6 for spacing). "More" takes one slot.
      // Side padding: 14px each side.
      const slotWidth = 58.0;
      const sidePad = 14.0;
      final available = cons.maxWidth - sidePad * 2;
      final slots = (available / slotWidth).floor().clamp(4, 10);
      final brandSlots = slots - 1; // one slot reserved for "More"
      final shown = kBrands.take(brandSlots).toList();
      final pri = ThemeManager.active.primary;

      return Padding(padding: const EdgeInsets.symmetric(horizontal: sidePad),
        child: SizedBox(height: 76, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...shown.map((b) {
              final s = selected == b;
              return GestureDetector(onTap: () => onPicked(b),
                child: SizedBox(width: 54, child: Column(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: s ? pri : Colors.transparent, width: 2.5)),
                    child: Padding(padding: const EdgeInsets.all(2), child: BrandLogo(name: b, size: 44))),
                  const SizedBox(height: 5),
                  Text(b, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, fontWeight: s ? FontWeight.w700 : FontWeight.w500,
                      color: s ? pri : C.textSub)),
                ])));
            }),
            // "More" button — opens full brand picker sheet
            GestureDetector(
              onTap: () async {
                final r = await showModalBottomSheet<String>(context: context, isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) => const BrandLogoSheet());
                if (r != null) onPicked(r);
              },
              child: SizedBox(width: 54, child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 50, height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: pri.withOpacity(0.1),
                    border: Border.all(color: pri.withOpacity(0.25), width: 1.5)),
                  child: Icon(Icons.grid_view_rounded, color: pri, size: 22)),
                const SizedBox(height: 5),
                Text('More', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: pri)),
              ]))),
          ])));
    });
  }
}

// Backward-compat alias
typedef _HomeBrandStrip = HomeBrandStrip;
