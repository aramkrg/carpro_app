import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/lang_store.dart';
import '../../core/helpers.dart';
import '../../widgets/shared_widgets.dart';
import 'step1_category.dart';
import 'step2_details.dart';
import 'step3_media.dart';
import 'step4_price.dart';
import 'step5_review.dart';

/// 6-step listing wizard. Step 6 = payment after pending approval.
class AddCarTab extends StatefulWidget {
  const AddCarTab({super.key});
  @override State<AddCarTab> createState() => _AddState();
}
class _AddState extends State<AddCarTab> {
  // REQ 6: 6 steps total (added payment step)
  static const _total = 6;
  String _cat = 'used';
  String _cond = 'clean';
  String _priceCur = 'USD';

  int get _step => addCarStepNotifier.value;
  set _step(int v) => addCarStepNotifier.value = v;

  @override void initState() {
    super.initState();
    langNotifier.addListener(_r);
    addCarStepNotifier.addListener(_r);
  }
  @override void dispose() {
    langNotifier.removeListener(_r);
    addCarStepNotifier.removeListener(_r);
    super.dispose();
  }
  void _r() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header + progress
      Container(color: Colors.white, child: SafeArea(bottom: false, child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 6), child: Row(children: [
          if (_step > 0) GestureDetector(onTap: () => _step = _step - 1,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20)),
          if (_step > 0) const SizedBox(width: 8),
          Expanded(child: Text(
            _step == 5 ? 'Payment' : T.g('add_car_title'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.navy))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${T.g('step')} ${_step + 1} ${T.g('of')} $_total',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.primary))),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: (_step + 1) / _total,
              backgroundColor: C.border, color: C.primary, minHeight: 5))),
      ]))),
      // Step body
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _body())),
      // Bottom button
      Container(padding: const EdgeInsets.fromLTRB(16, 10, 16, 28), color: Colors.white,
        child: _step < _total - 1
          ? PriBtn(label: _step == 4 ? 'Submit for Review' : T.g('next'), onTap: () => _step = _step + 1)
          : PriBtn(label: 'Pay & Publish', onTap: _onPayAndPublish)),
    ]);
  }

  void _onPayAndPublish() {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(children: [
        Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 24)),
        const SizedBox(width: 10),
        const Text('Payment Confirmed', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
          child: const Text('10,000 IQD deducted from your wallet.\nYour listing is now LIVE!',
            style: TextStyle(fontSize: 13, height: 1.5))),
        const SizedBox(height: 12),
        const Text('Your car will be visible to buyers immediately after admin approval.',
          style: TextStyle(fontSize: 12, color: C.textSub)),
      ]),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
          _step = 0; // Reset wizard
        }, child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700))),
      ],
    ));
  }

  Widget _body() {
    switch (_step) {
      case 0: return Step1Cat(cat: _cat, onChanged: (v) => setState(() => _cat = v));
      case 1: return Step2Details(cat: _cat, cond: _cond, onCond: (v) => setState(() => _cond = v));
      case 2: return const Step3Media();
      case 3: return Step4Price(cur: _priceCur, onCur: (v) => setState(() => _priceCur = v));
      case 4: return Step5Review(cat: _cat, cur: _priceCur);
      // REQ 6: Step 6 = Payment screen
      case 5: return _PaymentStep(cur: _priceCur);
      default: return const SizedBox();
    }
  }
}

/// REQ 6: Payment step — shown after pending approval
class _PaymentStep extends StatefulWidget {
  final String cur;
  const _PaymentStep({required this.cur});
  @override State<_PaymentStep> createState() => _PaymentStepState();
}
class _PaymentStepState extends State<_PaymentStep> {
  String _selectedPkg = 'basic';

  final _packages = [
    {'id': 'basic', 'name': 'Basic Listing', 'price': 10000, 'duration': '30 days', 'color': 0xFF1565C0, 'features': ['Listed in search results', 'Up to 10 photos', 'Standard visibility']},
    {'id': 'featured', 'name': 'Featured', 'price': 25000, 'duration': '30 days', 'color': 0xFFFF8F00, 'features': ['Top of search results', 'Up to 20 photos', 'Featured badge', '2x more views']},
    {'id': 'vip', 'name': 'VIP Listing', 'price': 50000, 'duration': '30 days', 'color': 0xFFFFB300, 'features': ['VIP carousel on home', 'Unlimited photos', 'Priority support', '5x more views', 'Reels feature enabled']},
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _packages.firstWhere((p) => p['id'] == _selectedPkg);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Status: pending
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.pending_actions_rounded, color: Colors.orange.shade700, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pending Review', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.orange.shade800, fontSize: 15)),
            const SizedBox(height: 2),
            const Text('Your listing has been submitted for admin review. Select a package to publish it.',
              style: TextStyle(fontSize: 12, color: C.textSub, height: 1.4)),
          ])),
        ])),
      const SizedBox(height: 20),
      const Text('Choose Your Package', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: C.navy)),
      const SizedBox(height: 12),
      ..._packages.map((pkg) {
        final isSel = _selectedPkg == pkg['id'];
        final col = Color(pkg['color'] as int);
        final features = pkg['features'] as List;
        return GestureDetector(
          onTap: () => setState(() => _selectedPkg = pkg['id'] as String),
          child: AnimatedContainer(duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSel ? col.withOpacity(0.06) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSel ? col : C.border, width: isSel ? 2 : 1),
              boxShadow: isSel ? [BoxShadow(color: col.withOpacity(0.15), blurRadius: 12)] : null),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(6)),
                  child: Text(pkg['name'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
                const Spacer(),
                Text('${(pkg['price'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} IQD',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: col)),
              ]),
              const SizedBox(height: 4),
              Text(pkg['duration'] as String, style: const TextStyle(fontSize: 11, color: C.textSub)),
              const SizedBox(height: 10),
              ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Icon(Icons.check_circle_rounded, size: 14, color: col),
                  const SizedBox(width: 6),
                  Text(f as String, style: const TextStyle(fontSize: 12, color: C.textMain)),
                ]))),
              if (isSel) ...[
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: col.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_rounded, size: 14, color: col),
                    const SizedBox(width: 4),
                    Text('Selected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: col)),
                  ])),
              ],
            ])));
      }),
      const SizedBox(height: 12),
      // Wallet balance
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: C.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.primary.withOpacity(0.15))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(Icons.account_balance_wallet_outlined, color: C.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Wallet Balance', style: TextStyle(fontSize: 13, color: C.textSub)),
          ]),
          const Text('45,000 IQD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.primary)),
        ])),
      const SizedBox(height: 8),
      Center(child: Text('Tap "Pay & Publish" to confirm payment and go live.',
        style: const TextStyle(fontSize: 11, color: C.textSub), textAlign: TextAlign.center)),
    ]);
  }
}
