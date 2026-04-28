
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/lang_store.dart';
import '../core/theme.dart';
import '../widgets/shared_widgets.dart';
import 'phone_screen.dart';

class LanguageScreen extends StatefulWidget {
  final bool fromProfile;
  const LanguageScreen({super.key, this.fromProfile = false});
  @override State<LanguageScreen> createState() => _LangState();
}
class _LangState extends State<LanguageScreen> {
  String? _sel;

  final _offline = const [
    {'code':'en',    'native':'English',         'latin':'English',         'flag':'EN','hex':'1565C0'},
    {'code':'ku_SO', 'native':'کوردی سۆرانی',    'latin':'Kurdish Sorani',  'flag':'KS','hex':'2E7D32'},
    {'code':'ku_BA', 'native':'Kurdî Badinî',     'latin':'Kurdish Badini',  'flag':'KB','hex':'E65100'},
    {'code':'ar',    'native':'العربية',          'latin':'Arabic',          'flag':'AR','hex':'6A1B9A'},
  ];
  final _online = const [
    {'code':'tr','native':'Türkçe',  'latin':'Turkish','flag':'TR','hex':'B71C1C'},
    {'code':'fa','native':'فارسی',   'latin':'Persian','flag':'FA','hex':'1B5E20'},
    {'code':'de','native':'Deutsch', 'latin':'German', 'flag':'DE','hex':'1A237E'},
    {'code':'fr','native':'Français','latin':'French', 'flag':'FR','hex':'880E4F'},
  ];

  void _pick(String code) { setLanguage(code); setState(() => _sel = code); }

  void _confirm() {
    if (_sel == null) return;
    if (widget.fromProfile) { Navigator.pop(context); return; }
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, _, _) => const PhoneScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, a, _, c) => FadeTransition(opacity: a, child: c)));
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Directionality(
      textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.fromProfile ? AppBar(
          backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: Icon(T.isRTL ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
              color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: Text(T.g('language'), style: const TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18)),
          centerTitle: true) : null,
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF0FF), Colors.white])),
          child: SafeArea(child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: sz.width * 0.06),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (!widget.fromProfile) ...[
                SizedBox(height: sz.height * 0.04),
                Center(child: Column(children: [
                  AppLogoBall(sz: 64),
                  const SizedBox(height: 10),
                  const Text('CarPro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: C.navy, letterSpacing: 2)),
                  const Text('Car Marketplace', style: TextStyle(fontSize: 11, color: C.textSub, letterSpacing: 3)),
                ])),
                SizedBox(height: sz.height * 0.03),
              ] else SizedBox(height: sz.height * 0.02),
              Center(child: Text(T.g('choose_lang'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.navy))),
              const SizedBox(height: 4),
              Center(child: Text(T.g('lang_sub'), style: const TextStyle(fontSize: 12, color: C.textSub))),
              const SizedBox(height: 18),
              _SectionBadge('Built-in · No internet needed', C.primary),
              const SizedBox(height: 10),
              ..._offline.map((l) => Padding(padding: const EdgeInsets.only(bottom: 9),
                child: _LangTile(data: l, selected: _sel == l['code'], onTap: () => _pick(l['code']!)))),
              const SizedBox(height: 10),
              _SectionBadge('More languages · Download once', C.amber),
              const SizedBox(height: 10),
              ..._online.map((l) => Padding(padding: const EdgeInsets.only(bottom: 9),
                child: _LangTile(data: l, selected: _sel == l['code'], onTap: () => _pick(l['code']!), isOnline: true))),
              const SizedBox(height: 18),
              PriBtn(label: T.g('continue'), onTap: _sel != null ? _confirm : null),
              SizedBox(height: sz.height * 0.04),
            ]))),
        ),
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  final String label; final Color color;
  const _SectionBadge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)));
}

class _LangTile extends StatelessWidget {
  final Map<String,String> data;
  final bool selected, isOnline;
  final VoidCallback onTap;
  const _LangTile({required this.data, required this.selected, required this.onTap, this.isOnline = false});
  @override
  Widget build(BuildContext context) {
    final col = Color(int.parse('FF${data['hex']!}', radix: 16));
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: selected ? col.withOpacity(0.07) : Colors.white,
          border: Border.all(color: selected ? col : C.border, width: selected ? 2 : 1.2),
          boxShadow: [BoxShadow(color: selected ? col.withOpacity(0.15) : Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: col.withOpacity(0.12)),
            child: Center(child: Text(data['flag']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: col)))),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data['native']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: selected ? col : C.textMain)),
            Text(data['latin']!, style: TextStyle(fontSize: 11, color: selected ? col.withOpacity(0.7) : C.textSub)),
          ])),
          if (isOnline && !selected) const Icon(Icons.download_outlined, size: 16, color: C.textSub),
          if (selected) Icon(Icons.check_circle_rounded, color: col, size: 22),
        ])));
  }
}
