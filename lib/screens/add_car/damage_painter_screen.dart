import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

// ═══════════════════════════════════════════════════════════════════
// 2D DAMAGE PAINTER — 5 views + photo upload + airbag toggle
// All views are OPTIONAL — leave any blank that don't apply.
// ═══════════════════════════════════════════════════════════════════
class DamagePainterScreen extends StatefulWidget {
  const DamagePainterScreen({super.key});
  @override State<DamagePainterScreen> createState() => _PainterState();
}

class _DamageView {
  final String key, label;
  final IconData icon;
  final double iconRotation; // radians; rotate same car icon to suggest different views
  const _DamageView(this.key, this.label, this.icon, this.iconRotation);
}

class _PainterState extends State<DamagePainterScreen> {
  // One stroke list per view. Empty list = view skipped (it's optional).
  final Map<String, List<Offset>> _strokes = {
    'top': [], 'front': [], 'back': [], 'left': [], 'right': [],
  };
  // Number of damage photos the user added (placeholder — wires to real picker in production)
  int _photoCount = 0;
  // Airbag deployment status — required toggle
  bool? _airbagsDeployed;

  static const _views = <_DamageView>[
    _DamageView('top',   'Top View',         Icons.directions_car_filled_rounded, 1.5708),  // 90°
    _DamageView('front', 'Front View',       Icons.directions_car_filled_rounded, 0),
    _DamageView('back',  'Back View',        Icons.directions_car_filled_rounded, 3.14159), // 180°
    _DamageView('left',  'Left Side View',   Icons.airport_shuttle_rounded, 0),
    _DamageView('right', 'Right Side View',  Icons.airport_shuttle_rounded, 3.14159),       // mirrored
  ];

  void _clearAll() => setState(() {
    for (final k in _strokes.keys) _strokes[k] = [];
    _photoCount = 0;
    _airbagsDeployed = null;
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('damage_map'), style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 16)),
          actions: [
            TextButton(onPressed: _clearAll,
              child: Text(T.g('clear'), style: const TextStyle(color: C.primary))),
            TextButton(onPressed: () => Navigator.pop(context),
              child: Text(T.g('done'), style: const TextStyle(color: C.primary, fontWeight: FontWeight.w700))),
          ]),
        body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: [
          // Intro card
          Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFEFF4FF), borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Icon(Icons.info_outline_rounded, color: C.primary, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text(
                'Mark painted or damaged panels on each view. All views are optional — only fill in what applies. You can also add real photos of damaged parts below.',
                style: TextStyle(fontSize: 12, color: C.textSub, height: 1.5))),
            ])),
          const SizedBox(height: 14),
          // Five view canvases
          ..._views.map((v) => Padding(padding: const EdgeInsets.only(bottom: 14),
            child: _ViewCanvas(view: v, strokes: _strokes[v.key]!,
              onAddStroke: (p) => setState(() => _strokes[v.key]!.add(p)),
              onClearView: () => setState(() => _strokes[v.key]!.clear())))),
          // Damage photos section
          _SectionHeader(icon: Icons.photo_camera_outlined,
            title: 'Photos of Damaged Parts',
            sub: 'Optional · Real photos help buyers see exact condition'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1),
            itemCount: 8,
            itemBuilder: (_, i) {
              if (i < _photoCount) {
                return Container(
                  decoration: BoxDecoration(color: C.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: C.primary.withOpacity(0.3))),
                  child: Stack(children: [
                    const Center(child: Icon(Icons.image_rounded, color: C.primary, size: 30)),
                    Positioned(top: 2, right: 2, child: GestureDetector(onTap: () => setState(() => _photoCount--),
                      child: Container(width: 20, height: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: C.red),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 14)))),
                  ]),
                );
              }
              if (i == _photoCount && _photoCount < 8) {
                return GestureDetector(onTap: () => setState(() => _photoCount++),
                  child: Container(decoration: BoxDecoration(color: const Color(0xFFF4F7FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: C.border, style: BorderStyle.solid)),
                    child: const Icon(Icons.add_a_photo_outlined, color: C.textSub, size: 26)));
              }
              return Container(decoration: BoxDecoration(color: const Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)));
            }),
          const SizedBox(height: 6),
          Text('$_photoCount of 8 photos added', style: const TextStyle(fontSize: 11, color: C.textSub)),
          const SizedBox(height: 18),
          // Airbag deployment toggle
          _SectionHeader(icon: Icons.airline_seat_legroom_extra_rounded,
            title: 'Airbag Deployment',
            sub: 'Required · Buyers need to know about previous airbag deployment'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _AirbagOption(label: 'Not Deployed', icon: Icons.check_circle_rounded, color: C.green,
              selected: _airbagsDeployed == false, onTap: () => setState(() => _airbagsDeployed = false))),
            const SizedBox(width: 10),
            Expanded(child: _AirbagOption(label: 'Deployed', icon: Icons.warning_rounded, color: C.red,
              selected: _airbagsDeployed == true, onTap: () => setState(() => _airbagsDeployed = true))),
          ]),
          const SizedBox(height: 14),
          // Legend
          Padding(padding: const EdgeInsets.all(8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 14, height: 14, decoration: BoxDecoration(shape: BoxShape.circle, color: C.red.withOpacity(0.7))),
            const SizedBox(width: 8),
            const Text('Painted / Damaged area', style: TextStyle(fontSize: 12, color: C.textSub)),
          ])),
        ]),
      ),
    );
  }
}

// One paint-able canvas for a single view
class _ViewCanvas extends StatelessWidget {
  final _DamageView view;
  final List<Offset> strokes;
  final ValueChanged<Offset> onAddStroke;
  final VoidCallback onClearView;
  const _ViewCanvas({required this.view, required this.strokes, required this.onAddStroke, required this.onClearView});

  @override
  Widget build(BuildContext context) {
    final hasStrokes = strokes.isNotEmpty;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white,
        border: Border.all(color: hasStrokes ? C.red.withOpacity(0.4) : C.border, width: hasStrokes ? 1.6 : 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 8), child: Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: C.primary.withOpacity(0.1)),
            child: Center(child: Text(view.label.split(' ').first[0],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: C.primary)))),
          const SizedBox(width: 10),
          Expanded(child: Text(view.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy))),
          if (hasStrokes) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: C.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text('${strokes.length} marks',
              style: const TextStyle(fontSize: 10, color: C.red, fontWeight: FontWeight.w700))),
          if (hasStrokes) const SizedBox(width: 6),
          if (hasStrokes) GestureDetector(onTap: onClearView,
            child: const Icon(Icons.refresh_rounded, color: C.textSub, size: 18))
          else const Text('Optional', style: TextStyle(fontSize: 10, color: C.textSub)),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: AspectRatio(aspectRatio: 16 / 10,
            child: GestureDetector(
              onPanUpdate: (d) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) onAddStroke(box.globalToLocal(d.globalPosition));
              },
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFF8F9FF), borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: C.border)),
                child: ClipRRect(borderRadius: BorderRadius.circular(10), child: CustomPaint(
                  painter: _DmgPainter(pts: strokes),
                  child: Center(child: Transform.rotate(
                    angle: view.iconRotation,
                    child: Icon(view.icon, size: 110, color: C.primary.withOpacity(0.18)))))))))),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon; final String title, sub;
  const _SectionHeader({required this.icon, required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: C.primary, size: 22),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: C.navy)),
        Text(sub,   style: const TextStyle(fontSize: 11, color: C.textSub)),
      ])),
    ]));
}

class _AirbagOption extends StatelessWidget {
  final String label; final IconData icon; final Color color; final bool selected; final VoidCallback onTap;
  const _AirbagOption({required this.label, required this.icon, required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
        color: selected ? color.withOpacity(0.08) : Colors.white,
        border: Border.all(color: selected ? color : C.border, width: selected ? 2 : 1.2)),
      child: Column(children: [
        Icon(icon, color: selected ? color : C.textSub, size: 26),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? color : C.textMain)),
      ])));
}

class _DmgPainter extends CustomPainter {
  final List<Offset> pts;
  const _DmgPainter({required this.pts});
  @override void paint(Canvas c, Size s) {
    for (final p in pts) c.drawCircle(p, 8, Paint()..color = C.red.withOpacity(0.6)..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(_DmgPainter o) => o.pts != pts;
}
