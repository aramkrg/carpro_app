import 'package:flutter/material.dart';
import '../core/app_flags.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/helpers.dart';
import 'messages/chat_screen.dart';

class CarDetailScreen extends StatelessWidget {
  final Map<String,dynamic> car;
  const CarDetailScreen({super.key, required this.car});

  String _msg() => T.g('interest_msg')
      .replaceAll('{car}', car['name'])
      .replaceAll('{price}', Cur.primary(car['price'] as double, car['cur']));

  @override
  Widget build(BuildContext context) {
    final pri = Cur.primary(car['price'] as double, car['cur']);
    final sec = Cur.secondary(car['price'] as double, car['cur']);
    const phone = '9647501234567';
    final waUrl  = 'https://wa.me/$phone?text=${Uri.encodeComponent(_msg())}';
    // Viber opens chat directly (Viber does not support pre-filled text in deep links)
    const vibUrl = 'viber://contact?number=$phone';

    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverAppBar(expandedHeight: 230, pinned: true, backgroundColor: C.primaryDk,
            leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context)),
            actions: [
              if (AppFlags.reportButton) IconButton(icon: const Icon(Icons.flag_outlined, color: Colors.white, size: 22), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white, size: 22), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0A1F5C)])),
              child: const Center(child: Icon(Icons.directions_car_filled_rounded, size: 120, color: Colors.white10))))),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(car['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 6),
              // Primary price (seller's chosen currency) large
              Text(pri, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: C.primary)),
              // Secondary price (converted) small grey
              Text(sec, style: const TextStyle(fontSize: 13, color: C.textSub)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _Spec(Icons.calendar_today_outlined, '${car['year']}'),
                _Spec(Icons.settings_outlined, car['trans']),
                _Spec(Icons.local_gas_station_outlined, car['fuel']),
                if (car['cat'] != 'new') _Spec(Icons.speed_outlined, '${_fmt(car['km'] as int)} ${T.g('km')}'),
                _Spec(Icons.location_on_outlined, car['city']),
              ]),
              const SizedBox(height: 14),
              const Divider(color: C.border),
              const SizedBox(height: 10),
              Text(T.g('desc'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.navy)),
              const SizedBox(height: 6),
              const Text('Excellent condition. Full service history. No accidents. All maintenance done at authorised service centre. Ready for immediate transfer.',
                style: TextStyle(fontSize: 13, color: C.textSub, height: 1.6)),
              const SizedBox(height: 80),
            ]))),
        ]),
        // ── 4 contact buttons ───────────────────────────────────────
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
          decoration: BoxDecoration(color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, -3))]),
          child: Row(children: [
            if (AppFlags.callButton)     Expanded(child: _CBtn(label: T.g('call'),      icon: Icons.call_rounded,       color: C.primary, onTap: () {})),
            if (AppFlags.callButton)     const SizedBox(width: 7),
            // WhatsApp — pre-filled message template
            if (AppFlags.whatsappButton) Expanded(child: _CBtn(label: T.g('whatsapp'),  icon: Icons.chat_rounded,       color: C.green,   onTap: () {})),
            if (AppFlags.whatsappButton) const SizedBox(width: 7),
            // Viber — opens chat directly (no pre-fill, protocol limitation)
            if (AppFlags.viberButton)    Expanded(child: _CBtn(label: T.g('viber'),     icon: Icons.video_call_rounded, color: C.viber,   onTap: () {})),
            if (AppFlags.viberButton)    const SizedBox(width: 7),
            if (AppFlags.chatEnabled)    Expanded(child: _OBtn(label: T.g('message'),   icon: Icons.message_outlined,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(name: car['name']))))),
          ])),
      ),
    );
  }
  static String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
}

class _Spec extends StatelessWidget {
  final IconData icon; final String label;
  const _Spec(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: C.border)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: C.primary), const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: C.textMain, fontWeight: FontWeight.w500)),
    ]));
}

class _CBtn extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _CBtn({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(onPressed: onTap, icon: Icon(icon, size: 15),
    label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 11), elevation: 0));
}

class _OBtn extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _OBtn({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 15),
    label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
    style: OutlinedButton.styleFrom(foregroundColor: C.primary, side: const BorderSide(color: C.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 11)));
}
