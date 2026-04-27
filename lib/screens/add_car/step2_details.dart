import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/helpers.dart';
import '../../data/brand_data.dart';
import '../../data/car_models.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/brand_logo.dart';
import 'damage_painter_screen.dart';

/// Step 2 of Add Car wizard:
/// Brand → Model → Trim cascading dropdowns + year/trans/fuel/city/condition.
/// For Used cars with painted/accident condition, opens damage painter.
/// For New cars, shows MSRP and ETA fields.
class Step2Details extends StatefulWidget {
  final String cat, cond;
  final ValueChanged<String> onCond;
  const Step2Details({super.key, required this.cat, required this.cond, required this.onCond});
  @override State<Step2Details> createState() => _Step2State();
}
class _Step2State extends State<Step2Details> {
  String? _brand, _model, _trim;

  Future<void> _pickBrand() async {
    final picked = await showModalBottomSheet<String>(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const BrandLogoSheet());
    if (picked != null) setState(() { _brand = picked; _model = null; _trim = null; });
  }

  @override
  Widget build(BuildContext context) {
    final condItems = [T.g('clean'), T.g('painted'), T.g('accident'), T.g('salvage')];
    final showPainter = (widget.cond == T.g('painted') || widget.cond == T.g('accident')) && AppFlags.damagePainter;
    final models = _brand != null ? getModels(_brand!) : <String>[];
    final trims  = (_brand != null && _model != null) ? getTrims(_brand!, _model!) : <String>[];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ── Brand selector (opens logo sheet) ──────────────────────
      FL(T.g('brand')), const SizedBox(height: 6),
      GestureDetector(onTap: _pickBrand, child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
        child: Row(children: [
          if (_brand != null) ...[
            BrandLogo(name: _brand!, size: 28),
            const SizedBox(width: 10),
            Text(_brand!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: C.textMain)),
          ] else
            const Text('Tap to select brand', style: TextStyle(fontSize: 14, color: Color(0xFFBBC4D8))),
          const Spacer(),
          const Icon(Icons.expand_more_rounded, color: C.textSub, size: 18),
        ]))),
      const SizedBox(height: 14),
      // ── Model dropdown — populated from selected brand ──────────
      FL(T.g('model')), const SizedBox(height: 6),
      FDrop(
        val: _model ?? (models.isNotEmpty ? models.first : 'Select brand first'),
        items: models.isNotEmpty ? models : ['Select brand first'],
        onChanged: (v) { if (v != null && models.contains(v)) setState(() { _model = v; _trim = null; }); }),
      const SizedBox(height: 14),
      // ── Trim dropdown — populated from selected model ───────────
      FL('Trim'), const SizedBox(height: 6),
      FDrop(
        val: _trim ?? (trims.isNotEmpty ? trims.first : 'Select model first'),
        items: trims.isNotEmpty ? trims : ['Select model first'],
        onChanged: (v) { if (v != null && trims.contains(v)) setState(() => _trim = v); }),
      const SizedBox(height: 14),
      FL(T.g('year')), const SizedBox(height: 6),
      // Year range 1900 → current year + 1, auto-calculated
      FDrop(val: YearHelper.allYears.first, items: YearHelper.allYears, onChanged: (_) {}),
      const SizedBox(height: 14),
      FL(T.g('trans')), const SizedBox(height: 6),
      FDrop(val: T.g('automatic'), items: [T.g('automatic'), T.g('manual'), 'CVT', 'DCT'], onChanged: (_) {}),
      const SizedBox(height: 14),
      FL(T.g('fuel')), const SizedBox(height: 6),
      FDrop(val: T.g('petrol'),
        items: [T.g('petrol'), T.g('diesel'), T.g('electric'), T.g('hybrid'), 'PHEV', 'LPG', 'Hydrogen'],
        onChanged: (_) {}),
      const SizedBox(height: 14),
      FL(T.g('city')), const SizedBox(height: 6),
      FDrop(val: kCities.first, items: kCities, onChanged: (_) {}),
      if (widget.cat == 'used') ...[
        const SizedBox(height: 14),
        FL(T.g('condition')), const SizedBox(height: 6),
        FDrop(val: condItems.first, items: condItems, onChanged: (v) { if (v != null) widget.onCond(v); }),
        if (showPainter) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DamagePainterScreen())),
            child: Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                color: C.red.withOpacity(0.06), border: Border.all(color: C.red.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.brush_rounded, color: C.red, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(T.g('damage_map'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.red)),
                  Text(T.g('paint_sub'),  style: const TextStyle(fontSize: 11, color: C.textSub)),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.textSub),
              ]))),
        ],
      ],
      if (widget.cat == 'new') ...[
        const SizedBox(height: 14),
        FL(T.g('msrp')), const SizedBox(height: 6),
        IFld(hint: T.g('msrp_hint'), icon: Icons.attach_money_rounded),
        const SizedBox(height: 14),
        FL(T.g('eta')), const SizedBox(height: 6),
        IFld(hint: T.g('eta_hint'), icon: Icons.calendar_today_outlined),
      ],
    ]);
  }
}

// Backward-compat alias
typedef _Step2Details = Step2Details;
