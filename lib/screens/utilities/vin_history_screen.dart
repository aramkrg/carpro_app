import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/shared_widgets.dart';

class VINHistoryScreen extends StatefulWidget {
  const VINHistoryScreen({super.key});

  @override
  State<VINHistoryScreen> createState() => _VINHistoryScreenState();
}

class _VINHistoryScreenState extends State<VINHistoryScreen> {
  final _vinController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _reportData;

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  Future<void> _fetchVINReport() async {
    if (_vinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid VIN')),
      );
      return;
    }

    setState(() => _loading = true);

    // Simulate API call to CARFAX/AutoCheck
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _loading = false;
      _reportData = {
        'vin': _vinController.text,
        'make': 'Honda',
        'model': 'Civic',
        'year': 2019,
        'mileage': 45000,
        'owners': 2,
        'accidents': 0,
        'serviceHistory': true,
        'titleStatus': 'Clean',
        'cost': 9.99,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIN History Report'),
        elevation: 0,
        backgroundColor: theme.bg,
        foregroundColor: theme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check Vehicle History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get detailed CARFAX/AutoCheck reports',
              style: TextStyle(color: C.textSub, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _vinController,
              decoration: InputDecoration(
                hintText: 'Enter VIN (17 characters)',
                hintStyle: TextStyle(color: C.textSub),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            PriBtn(
              label: _loading ? 'Fetching...' : 'Get Report',
              onTap: _loading ? null : _fetchVINReport,
              loading: _loading,
            ),
            if (_reportData != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _reportField('Make', _reportData!['make']),
                    _reportField('Model', _reportData!['model']),
                    _reportField('Year', _reportData!['year'].toString()),
                    _reportField('Mileage', '${_reportData!['mileage']} km'),
                    _reportField('Owners', _reportData!['owners'].toString()),
                    _reportField('Accidents', _reportData!['accidents'].toString()),
                    _reportField(
                      'Title Status',
                      _reportData!['titleStatus'],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Report Cost',
                            style: TextStyle(
                              color: C.textSub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${_reportData!['cost']}',
                            style: TextStyle(
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    PriBtn(
                      label: 'Purchase Report',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report purchased!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _reportField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: C.textSub),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
