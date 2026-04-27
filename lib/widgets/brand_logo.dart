import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';
import '../data/brand_data.dart';

// ═══════════════════════════════════════════════════════════════════
// BRAND LOGO WIDGETS
// In production, replace the colored letter-circle with actual brand
// logo images from assets/brand_logos/{name}.png
// ═══════════════════════════════════════════════════════════════════

/// Shows brand PNG from assets. Falls back to colored letter circle.
class BrandLogo extends StatelessWidget {
  final String name; final double size;
  const BrandLogo({super.key, required this.name, this.size = 44});

  /// Brand-name → file-name. e.g. "Land Rover" → "land_rover", "Mercedes" → "mercedes"
  String get _fileName => name.toLowerCase()
      .replaceAll(' ', '_')
      .replaceAll('-', '_')
      .replaceAll('é', 'e')
      .replaceAll('ë', 'e');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 1))]),
      child: ClipOval(child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Image.asset(
          'assets/brand_logos/$_fileName.png',
          width: size, height: size, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _LetterFallback(name: name, size: size)))));
  }
}

/// Fallback: colored circle with brand's first two letters.
class _LetterFallback extends StatelessWidget {
  final String name; final double size;
  const _LetterFallback({super.key, required this.name, required this.size});
  @override
  Widget build(BuildContext context) {
    final entry = kBrandData.firstWhere((b) => b['name'] == name,
      orElse: () => {'name': name, 'hex': '0D47A1'});
    final color = Color(int.parse('FF${entry['hex']!}', radix: 16));
    final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
    return Container(width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(child: Text(initials,
        style: TextStyle(fontSize: size * 0.34, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5))));
  }
}

// ─── Brand picker bottom sheet — grid of all brand logos ────────────
class BrandLogoSheet extends StatefulWidget {
  const BrandLogoSheet({super.key});
  @override State<BrandLogoSheet> createState() => _BLState();
}
class _BLState extends State<BrandLogoSheet> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
      ? kBrandData
      : kBrandData.where((b) => b['name']!.toLowerCase().contains(_query.toLowerCase())).toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.85, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
      builder: (_, scroll) => Container(padding: const EdgeInsets.all(16), child: Column(children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        Row(children: [
          Text(T.g('brand'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.navy)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 8),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search brands…',
            prefixIcon: const Icon(Icons.search_rounded, color: C.textSub, size: 20),
            filled: true, fillColor: const Color(0xFFF4F7FF),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.primary, width: 1.6)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10))),
        const SizedBox(height: 12),
        Expanded(child: GridView.builder(
          controller: scroll,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 14, childAspectRatio: 0.9),
          itemCount: filtered.length,
          itemBuilder: (_, i) {
            final name = filtered[i]['name']!;
            return GestureDetector(onTap: () => Navigator.pop(context, name),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                BrandLogo(name: name, size: 54),
                const SizedBox(height: 6),
                Text(name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: C.textMain)),
              ]));
          })),
      ])));
  }
}

// ─── Brand picker inline field (used in Search filters) ─────────────
class BrandPickerField extends StatefulWidget {
  final ValueChanged<String?> onPicked;
  const BrandPickerField({super.key, required this.onPicked});
  @override State<BrandPickerField> createState() => _BPFState();
}
class _BPFState extends State<BrandPickerField> {
  String? _picked;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      final r = await showModalBottomSheet<String>(
        context: context, isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => const BrandLogoSheet());
      if (r != null) { setState(() => _picked = r); widget.onPicked(r); }
    },
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
      child: Row(children: [
        if (_picked != null) ...[
          BrandLogo(name: _picked!, size: 24),
          const SizedBox(width: 8),
          Text(_picked!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: C.textMain)),
        ] else
          Text(T.g('all_brands'), style: const TextStyle(fontSize: 14, color: C.textMain)),
        const Spacer(),
        const Icon(Icons.expand_more_rounded, color: C.textSub, size: 18),
      ])));
}

// Private aliases for backward compatibility
typedef _BrandLogo = BrandLogo;
typedef _BrandLogoSheet = BrandLogoSheet;
typedef _BrandPickerField = BrandPickerField;
