import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/helpers.dart';
import '../../data/brand_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/currency_toggle.dart';
import '../../widgets/brand_logo.dart';

/// Permanent left-side filter panel on wide layouts (web, tablet).
class FilterPanel extends StatelessWidget {
  final String currency;
  final double min, max;
  final void Function(String, double, double) onChanged;
  const FilterPanel({super.key, required this.currency, required this.min, required this.max, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(color: Colors.white,
    child: ListView(padding: const EdgeInsets.all(14), children: [
      Text(T.g('filters'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
      const SizedBox(height: 14),
      FL(T.g('brand')), const SizedBox(height: 6),
      BrandPickerField(onPicked: (_) {}),
      const SizedBox(height: 12),
      // Year dropdown — auto-calculated range 1900 → current+1
      FL(T.g('year')), const SizedBox(height: 6),
      FDrop(val: T.g('any_year'),
        items: [T.g('any_year'), ...YearHelper.allYears.take(30)], onChanged: (_) {}),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: FL(T.g('price_range'))),
        CurrToggle(val: currency, onChanged: (v) => onChanged(v, min, max)),
      ]),
      const SizedBox(height: 4),
      Text(currency == 'USD'
          ? '${Cur.fmtUsd(min)} — ${Cur.fmtUsd(max)}'
          : '${Cur.fmtIqd(min*AppFlags.usdToIqd)} — ${Cur.fmtIqd(max*AppFlags.usdToIqd)}',
        style: const TextStyle(fontSize: 11, color: C.textSub)),
      RangeSlider(values: RangeValues(min, max), min: 0, max: 200000, divisions: 200, activeColor: C.primary,
        onChanged: (v) => onChanged(currency, v.start, v.end)),
      const SizedBox(height: 12),
      FL(T.g('city')), const SizedBox(height: 6),
      FDrop(val: T.g('all_cities'), items: [T.g('all_cities'), ...kCities], onChanged: (_) {}),
      const SizedBox(height: 18),
      ElevatedButton(onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: C.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Text(T.g('apply'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
    ]));
}

/// Modal bottom-sheet filter for narrow layouts (phone).
class FilterSheet extends StatefulWidget {
  final String currency;
  final double min, max;
  final void Function(String, double, double) onChanged;
  const FilterSheet({super.key, required this.currency, required this.min, required this.max, required this.onChanged});
  @override State<FilterSheet> createState() => _FSState();
}
class _FSState extends State<FilterSheet> {
  late String _cur;
  late double _min, _max;

  @override void initState() {
    super.initState();
    _cur = widget.currency; _min = widget.min; _max = widget.max;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Container(padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(T.g('filters'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.navy)),
          IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 10),
        FL(T.g('brand')), const SizedBox(height: 6),
        BrandPickerField(onPicked: (_) {}),
        const SizedBox(height: 10),
        FL(T.g('year')), const SizedBox(height: 6),
        FDrop(val: T.g('any_year'), items: [T.g('any_year'), ...YearHelper.allYears.take(30)], onChanged: (_) {}),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: FL(T.g('price_range'))),
          CurrToggle(val: _cur, onChanged: (v) => setState(() => _cur = v)),
        ]),
        Text(_cur == 'USD'
            ? '${Cur.fmtUsd(_min)} — ${Cur.fmtUsd(_max)}'
            : '${Cur.fmtIqd(_min*AppFlags.usdToIqd)} — ${Cur.fmtIqd(_max*AppFlags.usdToIqd)}',
          style: const TextStyle(fontSize: 11, color: C.textSub)),
        RangeSlider(values: RangeValues(_min, _max), min: 0, max: 200000, divisions: 200, activeColor: C.primary,
          onChanged: (v) => setState(() { _min = v.start; _max = v.end; })),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () { widget.onChanged(_cur, _min, _max); Navigator.pop(context); },
          style: ElevatedButton.styleFrom(backgroundColor: C.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            padding: const EdgeInsets.symmetric(vertical: 14)),
          child: Text(T.g('apply'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)))),
      ])));
}

// Backward-compat aliases
typedef _FilterPanel = FilterPanel;
typedef _FilterSheet = FilterSheet;
