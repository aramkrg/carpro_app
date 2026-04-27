import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({super.key, required this.name});
  @override State<ChatScreen> createState() => _ChatState();
}
class _ChatState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _msgs = <Map<String, dynamic>>[
    {'me': false, 'txt': 'Hello, is this car still available?', 't': '10:28 AM'},
    {'me': true,  'txt': 'Yes, still available!',               't': '10:30 AM'},
    {'me': false, 'txt': 'What is the lowest price?',           't': '10:31 AM'},
    {'me': true,  'txt': 'Best price is \$20,500.',             't': '10:32 AM'},
  ];

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _msgs.add({'me': true, 'txt': _ctrl.text.trim(), 't': 'Now'});
      _ctrl.clear();
    });
  }

  // ── Long-press menu: copy / reply / delete (only own messages can delete) ──
  void _showMsgMenu(int i, String text, bool isMine) {
    showModalBottomSheet(context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.copy_rounded, color: C.primary),
          title: const Text('Copy'),
          onTap: () { Clipboard.setData(ClipboardData(text: text)); Navigator.pop(ctx); }),
        ListTile(
          leading: const Icon(Icons.reply_rounded, color: C.primary),
          title: const Text('Reply'),
          onTap: () { Navigator.pop(ctx); _ctrl.text = '> $text\n'; }),
        if (isMine) ListTile(
          leading: const Icon(Icons.delete_outline_rounded, color: C.red),
          title: const Text('Delete', style: TextStyle(color: C.red)),
          onTap: () { setState(() => _msgs.removeAt(i)); Navigator.pop(ctx); }),
        const SizedBox(height: 8),
      ])));
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: C.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Row(children: [
            CircleAvatar(radius: 18, backgroundColor: C.primary.withOpacity(0.12),
              child: Text(widget.name[0],
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.primary))),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.navy)),
              Text(T.g('online'), style: const TextStyle(fontSize: 11, color: Colors.green)),
            ]),
          ])),
        body: Column(children: [
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: _msgs.length,
            itemBuilder: (_, i) {
              final m = _msgs[i];
              final me = m['me'] as bool;
              return Align(alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onLongPress: () => _showMsgMenu(i, m['txt'] as String, me),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                      color: me ? C.primary : Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                    child: Column(crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                      Text(m['txt'], style: TextStyle(fontSize: 14, color: me ? Colors.white : C.textMain)),
                      const SizedBox(height: 3),
                      Text(m['t'], style: TextStyle(fontSize: 10, color: me ? Colors.white60 : C.textSub)),
                    ]))));
            })),
          Container(padding: const EdgeInsets.fromLTRB(12, 8, 12, 20), color: Colors.white,
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl, decoration: InputDecoration(
                hintText: T.g('type_msg'), hintStyle: const TextStyle(color: Color(0xFFBBC4D8)),
                filled: true, fillColor: C.bg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)))),
              const SizedBox(width: 8),
              GestureDetector(onTap: _send, child: Container(width: 44, height: 44,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: C.primary),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
            ])),
        ]),
      ),
    );
  }
}
