import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../utilities/refill_wallet_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final double _balance = 0;

  final List<Map<String, dynamic>> _transactions = [
    {'type': 'debit', 'title': 'Private Listing Payment', 'subtitle': 'Paid for a private listing', 'amount': 10000, 'date': '2026-04-12 06:53 PM'},
    {'type': 'credit', 'title': 'Account Refilled', 'subtitle': 'Wallet refilled by FIB', 'amount': 10000, 'date': '2026-04-12 06:52 PM'},
    {'type': 'debit', 'title': 'Private Listing Payment', 'subtitle': 'Paid for a private listing', 'amount': 10000, 'date': '2025-08-20 03:02 PM'},
    {'type': 'credit', 'title': 'Account Refilled', 'subtitle': 'Wallet refilled by FIB', 'amount': 10000, 'date': '2025-08-20 02:59 PM'},
    {'type': 'debit', 'title': 'VIP Listing Fee', 'subtitle': 'Premium listing boost', 'amount': 50000, 'date': '2025-07-15 01:30 PM'},
  ];

  String _formatAmount(double n) {
    return n.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Balance header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  const Text('Wallet Balance', style: TextStyle(color: Colors.black54, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('${_formatAmount(_balance)} IQD', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),

            // ── Refill button ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Refill Wallet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RefillWalletScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Transaction history ─────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Transaction History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ..._buildTransactions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTransactions() {
    String? lastDate;
    final widgets = <Widget>[];

    for (final tx in _transactions) {
      final date = tx['date'].toString().split(' ')[0];
      if (date != lastDate) {
        lastDate = date;
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Text(tx['date'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ));
      }

      final isCredit = tx['type'] == 'credit';
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isCredit ? Icons.arrow_back : Icons.arrow_forward,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(tx['subtitle'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
            Text(
              '${_formatAmount((tx['amount'] as int).toDouble())} IQD',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ));

      widgets.add(Divider(color: Colors.grey.shade100, height: 1));
    }
    return widgets;
  }
}
