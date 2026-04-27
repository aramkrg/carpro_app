import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../widgets/shared_widgets.dart';

/// Step 3 of Add Car wizard: photo grid, video, 360 photo, voice note.
class Step3Media extends StatelessWidget {
  const Step3Media({super.key});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    FL(T.g('photos')), const SizedBox(height: 8),
    Container(width: double.infinity, height: 170,
      decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: C.border)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(Icons.add_photo_alternate_outlined, size: 44, color: C.textSub),
        SizedBox(height: 8),
        Text('Tap to add main photo', style: TextStyle(color: C.textSub, fontSize: 13)),
        Text('Minimum 3 photos required', style: TextStyle(color: Color(0xFFBBC4D8), fontSize: 11)),
      ])),
    const SizedBox(height: 10),
    Row(children: List.generate(4, (_) => Expanded(child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4), height: 68,
      decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
      child: const Icon(Icons.add_rounded, color: C.textSub))))),
    const SizedBox(height: 14),
    if (AppFlags.videoUpload) _MediaOpt(icon: Icons.videocam_outlined, title: T.g('video'), sub: 'Max 5 minutes'),
    if (AppFlags.photo360)    ...[const SizedBox(height: 8), _MediaOpt(icon: Icons.threesixty_rounded, title: T.g('p360'), sub: 'Interactive 360° view')],
    if (AppFlags.voiceNote)   ...[const SizedBox(height: 8), _MediaOpt(icon: Icons.mic_outlined,        title: T.g('voice'), sub: 'Max 30 seconds')],
  ]);
}

class _MediaOpt extends StatelessWidget {
  final IconData icon; final String title, sub;
  const _MediaOpt({required this.icon, required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: C.primary.withOpacity(0.1)),
        child: Icon(icon, color: C.primary, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text(sub,   style: const TextStyle(fontSize: 11, color: C.textSub)),
      ])),
      const Text('Optional', style: TextStyle(fontSize: 11, color: C.textSub)),
      const SizedBox(width: 6),
      const Icon(Icons.add_circle_outline_rounded, color: C.primary, size: 22),
    ]));
}

// Backward-compat alias
typedef _Step3Media = Step3Media;
