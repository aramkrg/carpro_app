import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';
import '../../widgets/currency_toggle.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override State<CalculatorScreen> createState() => _CalcState();
}
class _CalcState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override void dispose()   { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Calculator',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18)),
          bottom: TabBar(controller: _tab,
            indicatorColor: pri, labelColor: pri, unselectedLabelColor: C.textSub,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            tabs: const [Tab(text: 'Basic'), Tab(text: 'Car Loan')])),
        body: TabBarView(controller: _tab, children: const [_BasicCalc(), _LoanCalc()])));
  }
}

class _BasicCalc extends StatefulWidget {
  const _BasicCalc();
  @override State<_BasicCalc> createState() => _BasicCalcState();
}
class _BasicCalcState extends State<_BasicCalc> {
  String _expr = '';
  String _result = '0';

  void _press(String key) {
    setState(() {
      if (key == 'C') { _expr = ''; _result = '0'; }
      else if (key == '⌫') { if (_expr.isNotEmpty) _expr = _expr.substring(0, _expr.length - 1); }
      else if (key == '=') { _result = _eval(_expr); }
      else { _expr += key; _result = _eval(_expr); }
    });
  }

  /// Tiny safe expression evaluator. Handles + - × ÷ % and decimals.
  /// No external math package needed. Two-pass: × ÷ first, then + -.
  String _eval(String s) {
    if (s.isEmpty) return '0';
    try {
      s = s.replaceAll('×', '*').replaceAll('÷', '/');
      // Tokenize numbers and operators
      final toks = <String>[];
      var buf = '';
      for (final ch in s.split('')) {
        if ('0123456789.'.contains(ch)) buf += ch;
        else { if (buf.isNotEmpty) { toks.add(buf); buf = ''; } toks.add(ch); }
      }
      if (buf.isNotEmpty) toks.add(buf);
      // First pass: × ÷ %
      var i = 1;
      while (i < toks.length - 1) {
        if (toks[i] == '*' || toks[i] == '/' || toks[i] == '%') {
          final a = double.parse(toks[i - 1]);
          final b = double.parse(toks[i + 1]);
          double r;
          if (toks[i] == '*') r = a * b;
          else if (toks[i] == '/') r = b == 0 ? double.nan : a / b;
          else r = a * b / 100;
          toks.replaceRange(i - 1, i + 2, [r.toString()]);
        } else { i += 2; }
      }
      // Second pass: + -
      var r = double.parse(toks.first);
      i = 1;
      while (i < toks.length - 1) {
        final b = double.parse(toks[i + 1]);
        if (toks[i] == '+') r += b; else if (toks[i] == '-') r -= b;
        i += 2;
      }
      if (r.isNaN || r.isInfinite) return 'Error';
      // Format: trim trailing zeros
      if (r == r.truncateToDouble()) return r.toInt().toString();
      return r.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    } catch (e) { return _result; }
  }

  Widget _btn(String label, {Color? bg, Color? fg, int span = 1}) {
    final pri = ThemeManager.active.primary;
    final color = bg ?? Colors.white;
    final textColor = fg ?? (label == '='
      ? Colors.white
      : (['+','-','×','÷','%','C','⌫'].contains(label) ? pri : C.navy));
    return Expanded(flex: span, child: Padding(padding: const EdgeInsets.all(4),
      child: Material(color: color, borderRadius: BorderRadius.circular(14), elevation: 1,
        child: InkWell(onTap: () => _press(label), borderRadius: BorderRadius.circular(14),
          child: Container(height: 60, alignment: Alignment.center,
            child: Text(label,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textColor)))))));
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(20), color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_expr.isEmpty ? '0' : _expr, style: const TextStyle(fontSize: 18, color: C.textSub)),
          const SizedBox(height: 6),
          Text(_result, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: C.navy)),
        ])),
      Expanded(child: Padding(padding: const EdgeInsets.all(8),
        child: Column(children: [
          Expanded(child: Row(children: [_btn('C'), _btn('⌫'), _btn('%'), _btn('÷')])),
          Expanded(child: Row(children: [_btn('7'), _btn('8'), _btn('9'), _btn('×')])),
          Expanded(child: Row(children: [_btn('4'), _btn('5'), _btn('6'), _btn('-')])),
          Expanded(child: Row(children: [_btn('1'), _btn('2'), _btn('3'), _btn('+')])),
          Expanded(child: Row(children: [_btn('0', span: 2), _btn('.'), _btn('=', bg: pri, fg: Colors.white)])),
        ])))]);
  }
}

class _LoanCalc extends StatefulWidget {
  const _LoanCalc();
  @override State<_LoanCalc> createState() => _LoanCalcState();
}
class _LoanCalcState extends State<_LoanCalc> {
  final _price  = TextEditingController(text: '20000');
  final _down   = TextEditingController(text: '5000');
  final _rate   = TextEditingController(text: '8.5');
  final _months = TextEditingController(text: '60');
  String _currency = 'USD';

  @override void dispose() {
    _price.dispose(); _down.dispose(); _rate.dispose(); _months.dispose();
    super.dispose();
  }

  /// Standard loan amortization formula.
  /// monthly = P × [ r(1+r)^n / ((1+r)^n − 1) ]
  Map<String, double> _calc() {
    final p   = double.tryParse(_price.text)  ?? 0;
    final d   = double.tryParse(_down.text)   ?? 0;
    final apr = double.tryParse(_rate.text)   ?? 0;
    final n   = int.tryParse(_months.text)    ?? 1;
    final principal = (p - d).clamp(0, double.infinity);
    final r = (apr / 100) / 12;
    if (n == 0 || principal == 0) {
      return {'monthly': 0, 'total': 0, 'interest': 0, 'principal': principal.toDouble()};
    }
    double monthly;
    if (r == 0) {
      monthly = principal / n;
    } else {
      final pow = _pow(1 + r, n);
      monthly = principal * (r * pow) / (pow - 1);
    }
    final total = monthly * n;
    return {
      'monthly': monthly, 'total': total,
      'interest': total - principal, 'principal': principal.toDouble()
    };
  }

  double _pow(double x, int n) { double r = 1; for (int i = 0; i < n; i++) r *= x; return r; }

  String _fmt(double v) => _currency == 'USD'
    ? '\$${v.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},')}'
    : '${(v * AppFlags.usdToIqd).toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')} IQD';

  @override
  Widget build(BuildContext context) {
    final r = _calc();
    final pri = ThemeManager.active.primary;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [
        const Text('Currency:', style: TextStyle(fontSize: 13, color: C.textSub)),
        const Spacer(),
        CurrToggle(val: _currency, onChanged: (v) => setState(() => _currency = v)),
      ]),
      const SizedBox(height: 14),
      _LoanField(label: 'Car price',          ctrl: _price,  suffix: _currency, onChanged: () => setState(() {})),
      const SizedBox(height: 10),
      _LoanField(label: 'Down payment',       ctrl: _down,   suffix: _currency, onChanged: () => setState(() {})),
      const SizedBox(height: 10),
      _LoanField(label: 'Annual interest',    ctrl: _rate,   suffix: '%',       onChanged: () => setState(() {})),
      const SizedBox(height: 10),
      _LoanField(label: 'Loan term (months)', ctrl: _months, suffix: 'mo',      onChanged: () => setState(() {})),
      const SizedBox(height: 22),
      Container(padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [pri, ThemeManager.active.primaryDk]),
          boxShadow: [BoxShadow(color: pri.withOpacity(0.2), blurRadius: 14, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Monthly Payment', style: TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(_fmt(r['monthly']!),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          _LoanRow('Loan amount',    _fmt(r['principal']!)),
          _LoanRow('Total interest', _fmt(r['interest']!)),
          _LoanRow('Total to pay',   _fmt(r['total']!)),
        ])),
    ]);
  }
}

class _LoanField extends StatelessWidget {
  final String label, suffix;
  final TextEditingController ctrl;
  final VoidCallback onChanged;
  const _LoanField({required this.label, required this.ctrl, required this.suffix, required this.onChanged});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, color: C.textSub)),
    const SizedBox(height: 4),
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
