import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/shared_widgets.dart';

class TrafficFinesScreen extends StatefulWidget {
  const TrafficFinesScreen({super.key});

  @override
  State<TrafficFinesScreen> createState() => _TrafficFinesScreenState();
}

class _TrafficFinesScreenState extends State<TrafficFinesScreen> {
  final _plateController = TextEditingController();
  String _selectedProvince = 'Baghdad';
  bool _loading = false;
  List<Map<String, dynamic>>? _fines;

  final List<String> _provinces = [
    'Baghdad',
    'Basra',
    'Nineveh',
    'Diyala',
    'Anbar',
    'Najaf',
    'Karbala',
    'Sulaymaniyah',
    'Erbil',
    'Duhok',
  ];

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _checkFines() async {
    if (_plateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a plate number')),
      );
      return;
    }

    setState(() => _loading = true);

    // Simulate API call to government database
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _loading = false;
      _fines = [
        {
          'date': '2024-03-15',
          'violation': 'Speeding (80 km/h in 60 zone)',
          'amount': 50000,
          'status': 'Unpaid',
          'location': 'Jadriyah Street',
        },
        {
          'date': '2024-02-20',
          'violation': 'Expired License Plate',
          'amount': 100000,
          'status': 'Unpaid',
          'location': 'Abu Nuwas',
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    final totalFines = _fines
            ?.fold<int>(
              0,
              (sum, fine) => sum + (fine['amount'] as int),
            ) ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Fines Checker'),
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
              'Check Your Fines',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your plate number to check outstanding fines',
              style: TextStyle(color: C.textSub, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(
                hintText: 'Plate Number (e.g. ABC-123-XYZ)',
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
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedProvince,
              items: _provinces
                  .map(
                    (province) => DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedProvince = value!);
              },
            ),
            const SizedBox(height: 16),
            PriBtn(
              label: _loading ? 'Checking...' : 'Check Fines',
              onTap: _loading ? null : _checkFines,
              loading: _loading,
            ),
            if (_fines != null && _fines!.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Outstanding Fines Found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_fines!.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    ..._fines!.map((fine) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fine['violation'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    fine['status'],
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Date: ${fine['date']} | Location: ${fine['location']}',
                              style: TextStyle(
                                color: C.textSub,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amount: ${fine['amount']} IQD',
                              style: TextStyle(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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
                            'Total Outstanding',
                            style: TextStyle(
                              color: C.textSub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$totalFines IQD',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_fines != null && _fines!.isEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'No outstanding fines found!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
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
}
