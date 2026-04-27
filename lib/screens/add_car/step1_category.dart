import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

/// Step 1 of Add Car wizard: select Brand New vs Used.
class Step1Cat extends StatelessWidget {
  final String cat;
  final ValueChanged<String> onChanged;
  const Step1Cat({super.key, required this.cat, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(T.g('select_category'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.navy)),
    const SizedBox(height: 14),
    if (AppFlags.showBrandNew) _SelCard(title: T.g('brand_new'), sub: T.g('new_sub'),
      icon: Icons.star_rounded, sel: cat == 'new', color: C.green,
      onTap: () => onChanged('new')),
    if (AppFlags.showBrandNew) const SizedBox(height: 12),
    if (AppFlags.showUsed) _SelCard(title: T.g('used_car'), sub: T.g('used_sub'),
      icon: Icons.directions_car_rounded, sel: cat == 'used', color: C.primary,
      onTap: () => onChanged('used')),
  ]);
}

class _SelCard extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final bool sel;
  final Color color;
  final VoidCallback onTap;
  const _SelCard({required this.title, required this.sub, required this.icon,
    required this.sel, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
        color: sel ? color.withOpacity(0.07) : Colors.white,
        border: Border.all(color: sel ? color : C.border, width: sel ? 2 : 1.2),
        boxShadow: [BoxShadow(color: sel ? color.withOpacity(0.15) : Colors.black.withOpacity(0.03),
          blurRadius: 12, offset: const Offset(0, 3))]),
      child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
          child: Icon(icon, color: color, size: 26)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: sel ? color : C.textMain)),
          Text(sub,   style: const TextStyle(fontSize: 12, color: C.textSub)),
        ])),
        if (sel) Icon(Icons.check_circle_rounded, color: color, size: 24),
      ])));
}

// Backward-compat alias
typedef _Step1Cat = Step1Cat;
