import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';

/// License Plate Cover Generator.
/// Generates a CarPro-branded cover to overlay on license plate before posting photos.
class PlateCoverScreen extends StatefulWidget {
  const PlateCoverScreen({super.key});
  @override State<PlateCoverScreen> createState() => _PlateState();
}
class _PlateState extends State<PlateCoverScreen> {
  String _style = 'classic';
  final _plate = TextEditingController(text: 'A 12345');

  @override void dispose() { _plate.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Plate Cover',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: pri.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.info_outline_rounded, color: pri, size: 18),
              const SizedBox(width: 8),
              const Expanded(child: Text(
                'Generate a CarPro-branded cover to overlay on your license plate before posting photos. Protects privacy.',
                style: TextStyle(fontSize: 12, color: C.textSub, height: 1.4))),
            ])),
          const SizedBox(height: 18),
          // Live preview
          Container(width: double.infinity, height: 130,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.black87),
            child: Center(child: _PlateCoverPreview(style: _style, plate: _plate.text))),
          const SizedBox(height: 18),
          const Text('Style', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _StyleChip(label: 'Classic', val: 'classic', cur: _style,
              onTap: () => setState(() => _style = 'classic'))),
            const SizedBox(width: 8),
            Expanded(child: _StyleChip(label: 'Bold', val: 'bold', cur: _style,
              onTap: () => setState(() => _style = 'bold'))),
            const SizedBox(width: 8),
            Expanded(child: _StyleChip(label: 'Minimal', val: 'minimal', cur: _style,
              onTap: () => setState(() => _style = 'minimal'))),
          ]),
          const SizedBox(height: 18),
          const Text('Optional: enter plate text',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
          const SizedBox(height: 6),
          TextField(controller: _plate, onChanged: (_) => setState(() {}),
            decoration: InputDecoration(filled: true, fillColor: Colors.white,
              hintText: 'A 12345',
              border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: pri, width: 1.6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))),
          const SizedBox(height: 22),
          ElevatedButton.icon(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cover saved to gallery (Phase 1: real save)')));
          },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Save to gallery'),
            style: ElevatedButton.styleFrom(backgroundColor: pri, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)), elevation: 0)),
        ])));
  }
}

class _StyleChip extends StatelessWidget {
  final String label, val, cur;
  final VoidCallback onTap;
  const _StyleChip({required this.label, required this.val, required this.cur, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final sel = val == cur;
    final pri = ThemeManager.active.primary;
    return GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: sel ? pri : Colors.white,
          border: Border.all(color: sel ? pri : C.border)),
        child: Center(child: Text(label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
            color: sel ? Colors.white : C.textSub)))));
  }
}

class _PlateCoverPreview extends StatelessWidget {
  final String style, plate;
  const _PlateCoverPreview({required this.style, required this.plate});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    if (style == 'classic') {
      return Container(margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: [pri, ThemeManager.active.primaryDk])),
        child: Padding(padding: const EdgeInsets.all(12),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Icon(Icons.directions_car_rounded, color: Colors.white, size: 28),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('CARPRO',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900,
                  color: Colors.white, letterSpacing: 2)),
              Text(plate, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ]),
            const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
          ])));
    }
    if (style == 'bold') {
      return Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.black,
          border: Border.all(color: pri, width: 3)),
        child: const Padding(padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(child: Text('CARPRO',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
              color: Colors.white, letterSpacing: 6)))));
    }
    return Container(margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white.withOpacity(0.1)),
      child: const Padding(padding: EdgeInsets.symmetric(vertical: 14),
        child: Center(child: Text('carpro',
          style: TextStyle(fontSize: 18, color: Colors.white70, letterSpacing: 4)))));
  }
}
