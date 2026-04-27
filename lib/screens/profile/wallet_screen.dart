import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('wallet'),
            style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: [pri, ThemeManager.active.primaryDk]),
              boxShadow: [BoxShadow(color: pri.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 5))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Current Balance', style: TextStyle(fontSize: 13, color: Colors.white70)),
              SizedBox(height: 6),
              Text('45,000 IQD', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
              SizedBox(height: 2),
              Text('≈ \$34', style: TextStyle(fontSize: 13, color: Colors.white70)),
            ])),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _WalletAction(icon: Icons.add_rounded,    label: 'Top Up',  onTap: () {})),
            const SizedBox(width: 10),
            Expanded(child: _WalletAction(icon: Icons.history_rounded, label: 'History', onTap: () {})),
          ]),
          const SizedBox(height: 16),
          const Text('Recent Transactions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy)),
          const SizedBox(height: 8),
          _TxItem(title: 'Top up via ZainCash',         amount: '+50,000', when: 'Today',     positive: true),
          _TxItem(title: 'Listing fee — Toyota Camry',  amount: '-10,000', when: 'Today',     positive: false),
          _TxItem(title: 'VIP boost — 7 days',          amount: '-5,000',  when: 'Yesterday', positive: false),
        ])));
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _WalletAction({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.border)),
      child: Column(children: [
        Icon(icon, color: ThemeManager.active.primary, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.textMain)),
      ])));
}

class _TxItem extends StatelessWidget {
  final String title, amount, when; final bool positive;
  const _TxItem({required this.title, required this.amount, required this.when, required this.positive});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
      border: Border.all(color: C.border)),
    child: Row(children: [
      Container(width: 36, height: 36,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: (positive ? C.green : C.red).withOpacity(0.1)),
        child: Icon(positive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: positive ? C.green : C.red, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.navy)),
        Text(when,  style: const TextStyle(fontSize: 11, color: C.textSub)),
      ])),
      Text('$amount IQD',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: positive ? C.green : C.red)),
    ]));
}
