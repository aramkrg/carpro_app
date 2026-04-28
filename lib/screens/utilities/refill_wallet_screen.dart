import 'package:flutter/material.dart';
import '../../core/theme.dart';

class RefillWalletScreen extends StatefulWidget {
  const RefillWalletScreen({super.key});

  @override
  State<RefillWalletScreen> createState() => _RefillWalletScreenState();
}

class _RefillWalletScreenState extends State<RefillWalletScreen> {
  String? _selectedPackage;

  final List<Map<String, dynamic>> _packages = [
    {'id': 'pkg1', 'amount': 200000, 'bonus': 20000, 'total': 220000, 'popular': false},
    {'id': 'pkg2', 'amount': 300000, 'bonus': 30000, 'total': 330000, 'popular': true},
    {'id': 'pkg3', 'amount': 500000, 'bonus': 50000, 'total': 550000, 'popular': false},
    {'id': 'pkg4', 'amount': 900000, 'bonus': 100000, 'total': 1000000, 'popular': false},
  ];

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    return n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
            child: const Icon(Icons.arrow_back, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.headset_mic_outlined, size: 18),
            label: const Text('Call for help'),
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 12),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Refill Wallet', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Choose your perfect package', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 24),

            // ── Package grid ─────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: _packages.length,
                itemBuilder: (_, i) {
                  final pkg = _packages[i];
                  final isSelected = _selectedPackage == pkg['id'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPackage = pkg['id']),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? theme.primary : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected ? theme.primary.withOpacity(0.1) : Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pkg['popular'] == true)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Most Popular', style: TextStyle(fontSize: 10, color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                            ),
                          Text(
                            _formatNumber(pkg['amount']),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const Text('IQD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🎁 ', style: TextStyle(fontSize: 12)),
                                Text('+ ${_formatNumber(pkg['bonus'])} Free',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Get ${_formatNumber(pkg['total'])} IQD\nin your wallet',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Proceed button ────────────────────────────────────────
            if (_selectedPackage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final pkg = _packages.firstWhere((p) => p['id'] == _selectedPackage);
                    _showPaymentDialog(context, pkg);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Proceed to Pay ${_formatNumber(_packages.firstWhere((p) => p['id'] == _selectedPackage)['amount'])} IQD',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Map<String, dynamic> pkg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${_formatNumber(pkg['amount'])} IQD'),
            Text('Bonus: +${_formatNumber(pkg['bonus'])} IQD', style: const TextStyle(color: Colors.green)),
            const Divider(),
            Text('Total in wallet: ${_formatNumber(pkg['total'])} IQD', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wallet recharged with ${_formatNumber(pkg['total'])} IQD!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
            child: const Text('Pay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
