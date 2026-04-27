import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/lang_store.dart';
import '../../widgets/shared_widgets.dart';
import 'chat_screen.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});
  @override State<MessagesTab> createState() => _MsgState();
}
class _MsgState extends State<MessagesTab> {
  @override void initState() { super.initState(); langNotifier.addListener(_r); }
  @override void dispose()   { langNotifier.removeListener(_r); super.dispose(); }
  void _r() => setState(() {});

  final _chats = [
    {'name':'Ahmad',  'msg':'Hello, is this car still available?','time':'10:30 AM', 'unread':2,'online':true},
    {'name':'Soran',  'msg':'Yes, it is available.',              'time':'9:45 AM',  'unread':0,'online':true},
    {'name':'Haval',  'msg':'Can you send more photos?',          'time':'Yesterday','unread':0,'online':false},
    {'name':'Hero',   'msg':'Thanks!',                            'time':'Yesterday','unread':0,'online':false},
    {'name':'Dlavar', 'msg':'What is the lowest price?',          'time':'Monday',   'unread':1,'online':false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar2(title: T.g('msgs')),
      Expanded(child: _chats.isEmpty
        ? Center(child: Text(T.g('no_msgs'), style: const TextStyle(color: C.textSub, fontSize: 15)))
        : ListView.separated(padding: const EdgeInsets.all(14), itemCount: _chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: C.border),
            itemBuilder: (_, i) {
              final m = _chats[i];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatScreen(name: m['name'] as String))),
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [
                  Stack(children: [
                    CircleAvatar(radius: 24, backgroundColor: C.primary.withOpacity(0.12),
                      child: Text((m['name'] as String)[0],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.primary))),
                    if (m['online'] as bool) Positioned(right: 0, bottom: 0, child: Container(width: 12, height: 12,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green,
                        border: Border.all(color: Colors.white, width: 2)))),
                  ]),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m['name'] as String,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.navy)),
                    Text(m['msg'] as String,
                      style: const TextStyle(fontSize: 12, color: C.textSub),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(m['time'] as String, style: const TextStyle(fontSize: 11, color: C.textSub)),
                    if ((m['unread'] as int) > 0) ...[
                      const SizedBox(height: 4),
                      Container(width: 20, height: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: C.primary),
                        child: Center(child: Text('${m['unread']}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)))),
                    ],
                  ]),
                ])));
            })),
    ]);
  }
}
