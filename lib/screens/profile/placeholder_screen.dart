import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(title,
            style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.construction_rounded, size: 64, color: C.textSub.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.navy)),
          const SizedBox(height: 4),
          const Text('Coming soon', style: TextStyle(fontSize: 13, color: C.textSub)),
        ]))));
  }
}

class MessagesPlaceholder extends StatelessWidget {
  const MessagesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Messages');
}
