import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/helpers.dart';

/// Step 5 of Add Car wizard: review summary + sunk-cost paywall.
/// The publishing fee is revealed here, only at the final step.
class Step5Review extends StatelessWidget {
  final String cat, cur;
  const Step5Review({super.key, required this.cat, required this.cur});

  @override
  Widget build(BuildContext context) => Column(children: [
    Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: C.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.primary.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(T.g('review'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.navy)),
        const Divider(color: C.border, height: 20),
        _RR(T.g('category'), cat == 'new' ? T.g('brand_new') : T.g('used_car')),
        _RR(T.g('brand'), 'Toyota'),
        _RR(T.g('model'), 'Camry'),
        _RR(T.g('year'),  '${YearHelper.currentYear}'),
        _RR(T.g('price'), cur == 'USD' ? '\$24,000' : '31,440,000 IQD'),
        _RR(T.g('city'),  'Erbil'),
      ])),
    const SizedBox(height: 12),
    // SUNK COST PAYWALL — revealed only at final publish step
    Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.account_balance_wallet_outlined, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 8),
          Text(T.g('pub_fee'),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.orange.shade800)),
        ]),
        const SizedBox(height: 6),
        Text(T.g('fee_info'), style: const TextStyle(fontSize: 12, color: C.textSub)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(T.g('wallet_bal'), style: const TextStyle(fontSize: 13, color: C.textSub)),
          const Text('45,000 IQD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.primary)),
        ]),
      ])),
    const SizedBox(height: 8),
    Text(T.g('pending'), style: const TextStyle(fontSize: 12, color: C.textSub), textAlign: TextAlign.center),
  ]);
}

class _RR extends StatelessWidget {
  final String k, v;
  const _RR(this.k, this.v);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontSize: 13, color: C.textSub)),
      Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
    ]));
}

// Backward-compat alias
typedef _Step5Review = Step5Review;
