import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final notifs = [
      {'icon': Icons.check_circle_rounded, 'color': C.green,  'title': 'Listing approved',      'msg': 'Your Toyota Camry is now live',         'when': '2h ago'},
      {'icon': Icons.favorite_rounded,     'color': C.red,    'title': 'New favorite',          'msg': 'Someone saved your BMW 530i',           'when': '5h ago'},
      {'icon': Icons.chat_bubble_rounded,  'color': ThemeManager.active.primary, 'title': 'New message', 'msg': 'Ahmad sent you a message',         'when': 'Yesterday'},
      {'icon': Icons.warning_rounded,      'color': C.amber,  'title': 'Listing expiring soon', 'msg': 'Your Lexus listing expires in 5 days',  'when': '2 days ago'},
    ];
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('notifications'),
            style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18))),
        body: ListView.separated(padding: const EdgeInsets.all(14), itemCount: notifs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final n = notifs[i];
            return Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.border)),
              child: Row(children: [
                Container(width: 40, height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: (n['color'] as Color).withOpacity(0.1)),
                  child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(n['title'] as String,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy)),
                  Text(n['msg']   as String, style: const TextStyle(fontSize: 12, color: C.textSub)),
                  Text(n['when']  as String,
                    style: TextStyle(fontSize: 10, color: C.textSub.withOpacity(0.7))),
                ])),
              ]));
          })));
  }
}
