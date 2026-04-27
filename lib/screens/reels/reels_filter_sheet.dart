import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/sample_data.dart';
import '../../widgets/shared_widgets.dart';

/// Modal bottom sheet for filtering Reels by brand → model → trim.
/// Uses only brands/models/trims that actually appear in the current reels.
class ReelsFilterSheet extends StatefulWidget {
  final String? brand, model, trim;
  final void Function(String?, String?, String?) onApply;
  const ReelsFilterSheet({super.key, this.brand, this.model, this.trim, required this.onApply});
  @override State<ReelsFilterSheet> createState() => _RFSState();
}
class _RFSState extends State<ReelsFilterSheet> {
  String? _b, _m, _t;

  @override void initState() {
    super.initState();
    _b = widget.brand; _m = widget.model; _t = widget.trim;
  }

  @override
  Widget build(BuildContext context) {
    final brands = ['Any', ...kReels.map((r) => r.brand).toSet()];
    final models = _b == null || _b == 'Any'
      ? <String>['Any']
      : ['Any', ...kReels.where((r) => r.brand == _b).map((r) => r.model).toSet()];
    final trims  = _m == null || _m == 'Any'
      ? <String>['Any']
      : ['Any', ...kReels.where((r) => r.brand == _b && r.model == _m).map((r) => r.trim).toSet()];

    return Container(decoration: const BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: C.border))),
        const SizedBox(height: 14),
        const Text('Filter Reels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.navy)),
        const SizedBox(height: 16),
        FL('Brand'), const SizedBox(height: 6),
        FDrop(val: _b ?? 'Any', items: brands,
          onChanged: (v) => setState(() { _b = v == 'Any' ? null : v; _m = null; _t = null; })),
        const SizedBox(height: 12),
        FL('Model'), const SizedBox(height: 6),
        FDrop(val: _m ?? 'Any', items: models,
          onChanged: (v) => setState(() { _m = v == 'Any' ? null : v; _t = null; })),
        const SizedBox(height: 12),
        FL('Trim'), const SizedBox(height: 6),
        FDrop(val: _t ?? 'Any', items: trims,
          onChanged: (v) => setState(() => _t = v == 'Any' ? null : v)),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: OutlinedButton(
            onPressed: () { widget.onApply(null, null, null); Navigator.pop(context); },
            style: OutlinedButton.styleFrom(side: const BorderSide(color: C.border),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
            child: const Text('Clear all',
              style: TextStyle(color: C.textMain, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton(
            onPressed: () { widget.onApply(_b, _m, _t); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeManager.active.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)), elevation: 0),
            child: const Text('Apply',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
        ]),
      ]));
  }
}

// Backward-compat alias
typedef _ReelsFilterSheet = ReelsFilterSheet;
