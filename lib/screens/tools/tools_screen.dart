import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';
import 'calculator_screen.dart';
import 'qibla_screen.dart';
import 'fuel_cost_screen.dart';
import 'plate_cover_screen.dart';
import 'vin_check_screen.dart';

/// Tools hub — utilities accessed from Profile → Tools.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    final tools = [
      {'icon': Icons.calculate_outlined,         'color': pri,                     'title': 'Calculator',  'sub': 'Basic + loan financing',     'page': const CalculatorScreen()},
      {'icon': Icons.explore_outlined,           'color': const Color(0xFF2E7D32), 'title': 'Qibla Compass','sub': 'Direction toward Mecca',     'page': const QiblaScreen()},
      {'icon': Icons.local_gas_station_outlined, 'color': const Color(0xFFE65100), 'title': 'Fuel Cost',    'sub': 'Trip & monthly cost calc',   'page': const FuelCostScreen()},
      {'icon': Icons.directions_car_outlined,    'color': const Color(0xFF6A1B9A), 'title': 'Plate Cover',  'sub': 'CarPro-branded plate cover', 'page': const PlateCoverScreen()},
      {'icon': Icons.fingerprint_rounded,        'color': const Color(0xFF1565C0), 'title': 'VIN History',  'sub': 'Check car history by VIN',   'page': const VinCheckScreen()},
    ];
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Tools',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: GridView.builder(padding: const EdgeInsets.all(14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.0),
          itemCount: tools.length,
          itemBuilder: (_, i) {
            final t = tools[i];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => t['page'] as Widget)),
              child: Container(padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: (t['color'] as Color).withOpacity(0.07),
                    blurRadius: 10, offset: const Offset(0, 3))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: (t['color'] as Color).withOpacity(0.1)),
                    child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 22)),
                  const Spacer(),
                  Text(t['title'] as String,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.navy)),
                  const SizedBox(height: 2),
                  Text(t['sub'] as String,
                    style: const TextStyle(fontSize: 11, color: C.textSub)),
                ])));
          })));
  }
}
