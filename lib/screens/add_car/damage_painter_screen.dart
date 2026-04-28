import 'package:flutter/material.dart';
import '../../core/theme.dart';

class DamagePainterScreen extends StatefulWidget {
  final List<String> initialPainted;
  final Function(List<String>)? onSave;

  const DamagePainterScreen({
    super.key,
    this.initialPainted = const [],
    this.onSave,
  });

  @override
  State<DamagePainterScreen> createState() => _DamagePainterScreenState();
}

class _DamagePainterScreenState extends State<DamagePainterScreen> {
  String _bodyType = 'sedan'; // 'sedan' or 'suv'
  late Set<String> _painted;

  // All paintable parts for each body type
  final Map<String, List<_CarPart>> _parts = {
    'sedan': [
      _CarPart('hood', 'Hood', const Rect.fromLTWH(120, 120, 120, 60)),
      _CarPart('roof', 'Roof', const Rect.fromLTWH(100, 80, 160, 55)),
      _CarPart('trunk', 'Trunk', const Rect.fromLTWH(120, 195, 120, 55)),
      _CarPart('front_bumper', 'Front Bumper', const Rect.fromLTWH(115, 180, 130, 25)),
      _CarPart('rear_bumper', 'Rear Bumper', const Rect.fromLTWH(115, 250, 130, 25)),
      _CarPart('front_left_door', 'Front Left Door', const Rect.fromLTWH(60, 110, 65, 80)),
      _CarPart('rear_left_door', 'Rear Left Door', const Rect.fromLTWH(60, 175, 65, 70)),
      _CarPart('front_right_door', 'Front Right Door', const Rect.fromLTWH(235, 110, 65, 80)),
      _CarPart('rear_right_door', 'Rear Right Door', const Rect.fromLTWH(235, 175, 65, 70)),
      _CarPart('left_fender', 'Left Fender', const Rect.fromLTWH(50, 80, 55, 60)),
      _CarPart('right_fender', 'Right Fender', const Rect.fromLTWH(255, 80, 55, 60)),
      _CarPart('left_rear_fender', 'Left Rear Fender', const Rect.fromLTWH(50, 200, 55, 60)),
      _CarPart('right_rear_fender', 'Right Rear Fender', const Rect.fromLTWH(255, 200, 55, 60)),
    ],
    'suv': [
      _CarPart('hood', 'Hood', const Rect.fromLTWH(110, 100, 140, 70)),
      _CarPart('roof', 'Roof', const Rect.fromLTWH(90, 55, 180, 65)),
      _CarPart('tailgate', 'Tailgate', const Rect.fromLTWH(110, 205, 140, 65)),
      _CarPart('front_bumper', 'Front Bumper', const Rect.fromLTWH(105, 170, 150, 30)),
      _CarPart('rear_bumper', 'Rear Bumper', const Rect.fromLTWH(105, 270, 150, 30)),
      _CarPart('front_left_door', 'Front Left Door', const Rect.fromLTWH(45, 105, 70, 90)),
      _CarPart('rear_left_door', 'Rear Left Door', const Rect.fromLTWH(45, 180, 70, 80)),
      _CarPart('front_right_door', 'Front Right Door', const Rect.fromLTWH(245, 105, 70, 90)),
      _CarPart('rear_right_door', 'Rear Right Door', const Rect.fromLTWH(245, 180, 70, 80)),
      _CarPart('left_fender', 'Left Fender', const Rect.fromLTWH(35, 65, 65, 70)),
      _CarPart('right_fender', 'Right Fender', const Rect.fromLTWH(260, 65, 65, 70)),
      _CarPart('left_rear_fender', 'Left Rear Fender', const Rect.fromLTWH(35, 200, 65, 70)),
      _CarPart('right_rear_fender', 'Right Rear Fender', const Rect.fromLTWH(260, 200, 65, 70)),
    ],
  };

  @override
  void initState() {
    super.initState();
    _painted = Set.from(widget.initialPainted);
  }

  void _togglePart(String id) {
    setState(() {
      if (_painted.contains(id)) _painted.remove(id);
      else _painted.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;
    final parts = _parts[_bodyType]!;
    final paintedNames = parts.where((p) => _painted.contains(p.id)).map((p) => p.label).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painted Parts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave?.call(_painted.toList());
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Body type selector ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _bodyType = 'sedan'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _bodyType == 'sedan' ? theme.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _bodyType == 'sedan' ? theme.primary : Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car, color: _bodyType == 'sedan' ? Colors.white : Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text('Sedan', style: TextStyle(fontWeight: FontWeight.w600, color: _bodyType == 'sedan' ? Colors.white : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _bodyType = 'suv'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _bodyType == 'suv' ? theme.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _bodyType == 'suv' ? theme.primary : Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.airport_shuttle, color: _bodyType == 'suv' ? Colors.white : Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text('SUV', style: TextStyle(fontWeight: FontWeight.w600, color: _bodyType == 'suv' ? Colors.white : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Instruction ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.amber.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tap on the car body parts that have been painted or repaired',
                      style: TextStyle(color: Colors.amber.shade800, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Car sketch with tappable parts ────────────────────────────
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                final pos = details.localPosition;
                for (final part in parts) {
                  if (part.rect.contains(pos)) {
                    _togglePart(part.id);
                    break;
                  }
                }
              },
              child: CustomPaint(
                painter: _CarBodyPainter(bodyType: _bodyType, parts: parts, painted: _painted),
                child: Container(width: double.infinity),
              ),
            ),
          ),

          // ── Painted parts list ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Painted Parts (${_painted.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    if (_painted.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _painted.clear()),
                        child: Text('Clear All', style: TextStyle(color: theme.primary, fontSize: 13)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (paintedNames.isEmpty)
                  Text('No parts selected', style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: paintedNames.map((name) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Text(name, style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
              ],
            ),
          ),

          // ── Part selector list ─────────────────────────────────────
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: parts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final part = parts[i];
                final isPainted = _painted.contains(part.id);
                return GestureDetector(
                  onTap: () => _togglePart(part.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPainted ? Colors.orange.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isPainted ? Colors.orange.shade400 : Colors.grey.shade300),
                    ),
                    child: Text(
                      part.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPainted ? Colors.orange.shade800 : Colors.grey.shade700,
                        fontWeight: isPainted ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data class for car parts ─────────────────────────────────────────────
class _CarPart {
  final String id;
  final String label;
  final Rect rect;
  const _CarPart(this.id, this.label, this.rect);
}

// ── Custom painter for car sketch ─────────────────────────────────────────
class _CarBodyPainter extends CustomPainter {
  final String bodyType;
  final List<_CarPart> parts;
  final Set<String> painted;

  _CarBodyPainter({required this.bodyType, required this.parts, required this.painted});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 360;

    // Draw car outline (simplified top-down view)
    _drawCarOutline(canvas, size, scale);

    // Draw each part
    for (final part in parts) {
      final scaledRect = Rect.fromLTWH(
        part.rect.left * scale,
        part.rect.top * scale,
        part.rect.width * scale,
        part.rect.height * scale,
      );
      final isPainted = painted.contains(part.id);
      final paint = Paint()
        ..color = isPainted ? Colors.orange.withOpacity(0.6) : Colors.blue.withOpacity(0.08)
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = isPainted ? Colors.orange.shade700 : Colors.blue.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = isPainted ? 2.0 : 1.0;

      final rRect = RRect.fromRectAndRadius(scaledRect, const Radius.circular(6));
      canvas.drawRRect(rRect, paint);
      canvas.drawRRect(rRect, borderPaint);

      // Draw label
      if (isPainted) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: part.label.split(' ').last,
            style: TextStyle(color: Colors.orange.shade900, fontSize: 9 * scale, fontWeight: FontWeight.w600),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: scaledRect.width);
        textPainter.paint(canvas, Offset(scaledRect.left + (scaledRect.width - textPainter.width) / 2, scaledRect.top + (scaledRect.height - textPainter.height) / 2));
      }
    }
  }

  void _drawCarOutline(Canvas canvas, Size size, double scale) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (bodyType == 'sedan') {
      // Sedan top-down silhouette
      final path = Path();
      final cx = size.width / 2;
      path.moveTo(cx - 55 * scale, 35 * scale);
      path.quadraticBezierTo(cx, 20 * scale, cx + 55 * scale, 35 * scale);
      path.lineTo(cx + 70 * scale, 160 * scale);
      path.quadraticBezierTo(cx + 75 * scale, 195 * scale, cx + 70 * scale, 225 * scale);
      path.quadraticBezierTo(cx, 250 * scale, cx - 70 * scale, 225 * scale);
      path.lineTo(cx - 70 * scale, 160 * scale);
      path.quadraticBezierTo(cx - 75 * scale, 55 * scale, cx - 55 * scale, 35 * scale);
      canvas.drawPath(path, paint);
    } else {
      // SUV top-down silhouette (wider/taller)
      final path = Path();
      final cx = size.width / 2;
      path.moveTo(cx - 65 * scale, 30 * scale);
      path.quadraticBezierTo(cx, 15 * scale, cx + 65 * scale, 30 * scale);
      path.lineTo(cx + 85 * scale, 170 * scale);
      path.quadraticBezierTo(cx + 88 * scale, 210 * scale, cx + 80 * scale, 250 * scale);
      path.quadraticBezierTo(cx, 275 * scale, cx - 80 * scale, 250 * scale);
      path.lineTo(cx - 85 * scale, 170 * scale);
      path.quadraticBezierTo(cx - 88 * scale, 55 * scale, cx - 65 * scale, 30 * scale);
      canvas.drawPath(path, paint);
    }

    // Center line
    final dashedPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(size.width / 2, 20 * scale), Offset(size.width / 2, size.height - 20 * scale), dashedPaint);
  }

  @override
  bool shouldRepaint(covariant _CarBodyPainter old) =>
      old.painted != painted || old.bodyType != bodyType;
}
