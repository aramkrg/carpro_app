import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';
import '../../widgets/currency_toggle.dart';

/// Fuel Cost Calculator.
/// Distance: km / miles. Consumption: L/100km / km/L / mpg. Currency: IQD / USD.
class FuelCostScreen extends StatefulWidget {
  const FuelCostScreen({super.key});
  @override State<FuelCostScreen> createState() => _FuelState();
}
class _FuelState extends State<FuelCostScreen> {
  final _distance    = TextEditingController(text: '100');
  final _consumption = TextEditingController(text: '8.5');
  final _price       = TextEditingController(text: '750');
  String _distanceUnit    = 'km';
  String _consumptionUnit = 'L/100km';
  String _currency        = 'IQD';

  @override void dispose() {
    _distance.dispose(); _consumption.dispose(); _price.dispose();
    super.dispose();
  }

  Map<String, double> _calc() {
    final dist = double.tryParse(_distance.text)    ?? 0;
    final cons = double.tryParse(_consumption.text) ?? 0;
    final pr   = double.tryParse(_price.text)       ?? 0;
    // Normalize distance to km
    final distKm = _distanceUnit == 'miles' ? dist * 1.60934 : dist;
    // Normalize consumption to L/100km
    double l100;
    if (_consumptionUnit == 'L/100km')   l100 = cons;
    else if (_consumptionUnit == 'km/L') l100 = cons == 0 ? 0 : 100 / cons;
    else /* mpg */                       l100 = cons == 0 ? 0 : 235.214583 / cons;
    final litres = (distKm / 100) * l100;
    final cost = litres * pr;
    return {'litres': litres, 'cost': cost, 'monthly': cost * 30, 'yearly': cost * 365};
  }

  String _fmtCost(double v) {
    final s = v.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return _currency == 'USD' ? '\$$s' : '$s IQD';
  }

  @override
  Widget build(BuildContext context) {
    final r = _calc();
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Fuel Cost',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          const Text('Distance', style: TextStyle(fontSize: 12, color: C.textSub)),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: _LoanField(label: '', ctrl: _distance,
              suffix: _distanceUnit, onChanged: () => setState(() {}))),
            const SizedBox(width: 8),
            _UnitChip(value: 'km',    sel: _distanceUnit == 'km',    onTap: () => setState(() => _distanceUnit = 'km')),
            const SizedBox(width: 4),
            _UnitChip(value: 'miles', sel: _distanceUnit == 'miles', onTap: () => setState(() => _distanceUnit = 'miles')),
          ]),
          const SizedBox(height: 14),
          const Text('Fuel consumption', style: TextStyle(fontSize: 12, color: C.textSub)),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: _LoanField(label: '', ctrl: _consumption, suffix: '',
              onChanged: () => setState(() {}))),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            _UnitChip(value: 'L/100km', sel: _consumptionUnit == 'L/100km', onTap: () => setState(() => _consumptionUnit = 'L/100km')),
            const SizedBox(width: 4),
            _UnitChip(value: 'km/L',    sel: _consumptionUnit == 'km/L',    onTap: () => setState(() => _consumptionUnit = 'km/L')),
            const SizedBox(width: 4),
            _UnitChip(value: 'mpg',     sel: _consumptionUnit == 'mpg',     onTap: () => setState(() => _consumptionUnit = 'mpg')),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            const Expanded(child: Text('Fuel price (per litre)',
              style: TextStyle(fontSize: 12, color: C.textSub))),
            CurrToggle(val: _currency, onChanged: (v) => setState(() => _currency = v)),
          ]),
          const SizedBox(height: 4),
          _LoanField(label: '', ctrl: _price, suffix: _currency, onChanged: () => setState(() {})),
          const SizedBox(height: 22),
          Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: [pri, ThemeManager.active.primaryDk]),
              boxShadow: [BoxShadow(color: pri.withOpacity(0.2), blurRadius: 14, offset: const Offset(0, 4))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Trip cost', style: TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 4),
              Text(_fmtCost(r['cost']!),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 4),
              Text('${r['litres']!.toStringAsFixed(1)} litres needed',
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 14),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
              _LoanRow('If daily — monthly', _fmtCost(r['monthly']!)),
              _LoanRow('If daily — yearly',  _fmtCost(r['yearly']!)),
            ])),
        ])));
  }
}

// Local copies of the fields/rows used in calculator_screen.dart (kept private here
// so we don't have to expose them publicly).
class _LoanField extends StatelessWidget {
  final String label, suffix;
  final TextEditingController ctrl;
  final VoidCallback onChanged;
  const _LoanField({required this.label, required this.ctrl, required this.suffix, required this.onChanged});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (label.isNotEmpty) ...[
      Text(label, style: const TextStyle(fontSize: 12, color: C.textSub)),
      const SizedBox(height: 4),
    ],
    TextField(controller: ctrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(filled: true, fillColor: Colors.white,
        suffixText: suffix, suffixStyle: const TextStyle(color: C.textSub, fontSize: 13),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ThemeManager.active.primary, width: 1.6)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))),
  ]);
}

class _LoanRow extends StatelessWidget {
  final String k, v;
  const _LoanRow(this.k, this.v);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
    ]));
}

class _UnitChip extends StatelessWidget {
  final String value;
  final bool sel;
  final VoidCallback onTap;
  const _UnitChip({required this.value, required this.sel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
          color: sel ? pri : Colors.white,
          border: Border.all(color: sel ? pri : C.border)),
        child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
          color: sel ? Colors.white : C.textSub))));
  }
}
