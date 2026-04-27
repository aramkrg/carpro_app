import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';

/// VIN History Check.
/// Mock implementation. Real Phase 1 wiring: replace `_mockLookup`
/// with an HTTP call to your VIN data provider (Carfax, AutoCheck, etc.).
class VinCheckScreen extends StatefulWidget {
  const VinCheckScreen({super.key});
  @override State<VinCheckScreen> createState() => _VinState();
}
class _VinState extends State<VinCheckScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  /// Validates VIN: 17 chars, alphanumeric, no I/O/Q (forbidden in real VINs).
  bool _isValidVin(String v) {
    if (v.length != 17) return false;
    final re = RegExp(r'^[A-HJ-NPR-Z0-9]+$');
    return re.hasMatch(v.toUpperCase());
  }

  Future<void> _check() async {
    final vin = _ctrl.text.trim().toUpperCase();
    if (!_isValidVin(vin)) {
      setState(() => _error = 'VIN must be exactly 17 characters (no I, O, or Q)');
      return;
    }
    setState(() { _loading = true; _error = null; _result = null; });
    await Future.delayed(const Duration(milliseconds: 1400)); // simulate API
    setState(() { _loading = false; _result = _mockLookup(vin); });
  }

  // Mock data generator. Real Phase 1: replace with HTTP call.
  Map<String, dynamic> _mockLookup(String vin) {
    // Use VIN char sum to deterministically generate plausible history
    final seed = vin.codeUnits.fold<int>(0, (a, b) => a + b);
    final accidents = seed % 4;
    final owners = (seed % 3) + 1;
    final mileageOk = seed % 5 != 0;
    return {
      'vin': vin,
      'year': 2018 + (seed % 7),
      'make': ['Toyota','BMW','Mercedes','Honda','Ford'][seed % 5],
      'model': ['Camry','3 Series','C-Class','Civic','F-150'][seed % 5],
      'accidents': accidents,
      'owners': owners,
      'mileageConsistent': mileageOk,
      'lastReported': '${2024 + (seed % 2)}-${(seed % 11) + 1}-${(seed % 27) + 1}',
      'records': [
        {'date': '2019-03-15', 'event': 'Vehicle registered',          'location': 'Dubai, UAE'},
        if (accidents > 0) {'date': '2021-07-22', 'event': 'Minor collision reported', 'location': 'Abu Dhabi, UAE'},
        if (accidents > 1) {'date': '2022-11-08', 'event': 'Repair completed',         'location': 'Service center'},
        {'date': '2023-04-10', 'event': 'Imported to Iraq',            'location': 'Erbil, Iraq'},
        if (owners > 1)    {'date': '2023-06-18', 'event': 'Ownership transferred',    'location': 'Erbil, Iraq'},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('VIN History',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text(
                'Demo mode: results are simulated. Real VIN data integration in Phase 1.',
                style: TextStyle(fontSize: 12, color: Color(0xFF7B5800)))),
            ])),
          const SizedBox(height: 14),
          const Text('Enter VIN (17 characters)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
          const SizedBox(height: 6),
          TextField(controller: _ctrl, maxLength: 17,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
            decoration: InputDecoration(filled: true, fillColor: Colors.white,
              hintText: 'e.g. JT2BG22K1W0123456', counterText: '',
              prefixIcon: const Icon(Icons.fingerprint_rounded, color: C.textSub),
              border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: pri, width: 1.6)))),
          if (_error != null) ...[
            const SizedBox(height: 6),
            Text(_error!, style: const TextStyle(color: C.red, fontSize: 12)),
          ],
          const SizedBox(height: 14),
          ElevatedButton.icon(onPressed: _loading ? null : _check,
            icon: _loading
              ? const SizedBox(width: 16, height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.search_rounded),
            label: Text(_loading ? 'Checking...' : 'Check VIN'),
            style: ElevatedButton.styleFrom(backgroundColor: pri, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)), elevation: 0)),
          if (_result != null) ...[
            const SizedBox(height: 22),
            _VinResultCard(result: _result!),
          ],
        ])));
  }
}

class _VinResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  const _VinResultCard({required this.result});
  @override
  Widget build(BuildContext context) {
    final acc = result['accidents'] as int;
    final owners = result['owners'] as int;
    final mileageOk = result['mileageConsistent'] as bool;
    final scoreOK = acc == 0 && mileageOk && owners <= 2;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Verdict banner
      Container(width: double.infinity, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
          color: scoreOK ? C.green.withOpacity(0.1) : Colors.amber.withOpacity(0.12),
          border: Border.all(color: scoreOK ? C.green : Colors.amber, width: 1.5)),
        child: Row(children: [
          Icon(scoreOK ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
            color: scoreOK ? C.green : Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(scoreOK ? 'Clean record' : 'Issues found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                color: scoreOK ? C.green : const Color(0xFF7B5800))),
            Text('${result['year']} ${result['make']} ${result['model']}',
              style: const TextStyle(fontSize: 13, color: C.textSub)),
          ])),
        ])),
      const SizedBox(height: 14),
      // Stat grid
      Row(children: [
        Expanded(child: _VinStat(label: 'Accidents', value: '$acc', icon: Icons.car_crash_outlined,
          color: acc == 0 ? C.green : (acc <= 1 ? Colors.amber : C.red))),
        const SizedBox(width: 8),
        Expanded(child: _VinStat(label: 'Owners', value: '$owners', icon: Icons.people_outline_rounded,
          color: owners <= 2 ? C.green : Colors.amber)),
        const SizedBox(width: 8),
        Expanded(child: _VinStat(label: 'Mileage', value: mileageOk ? 'OK' : 'Check', icon: Icons.speed_outlined,
          color: mileageOk ? C.green : C.red)),
      ]),
      const SizedBox(height: 16),
      const Text('History timeline',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.navy)),
      const SizedBox(height: 8),
      ...(result['records'] as List).map((rec) {
        final r = rec as Map<String, dynamic>;
        return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: C.border)),
          child: Row(children: [
            Container(width: 8, height: 8,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: C.primary)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['event'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
              Text('${r['date']} · ${r['location']}',
                style: const TextStyle(fontSize: 11, color: C.textSub)),
            ])),
          ]));
      }),
    ]);
  }
}

class _VinStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _VinStat({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
      border: Border.all(color: C.border)),
    child: Column(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: C.textSub)),
    ]));
}
