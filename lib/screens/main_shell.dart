import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';
import '../core/lang_store.dart';
import 'home/home_tab.dart';
import 'search/search_tab.dart';
import 'reels/reels_tab.dart';
import 'add_car/add_car_tab.dart';
import 'messages/messages_tab.dart';
import 'profile/profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _ShellState();
}
class _ShellState extends State<MainShell> {
  int _idx = 0;

  @override void initState() {
    super.initState();
    langNotifier.addListener(_r);
    themeNotifier.addListener(_r);
    mainTabNotifier.addListener(_onTabRequest);
  }
  @override void dispose() {
    langNotifier.removeListener(_r);
    themeNotifier.removeListener(_r);
    mainTabNotifier.removeListener(_onTabRequest);
    super.dispose();
  }
  void _r() => setState(() {});
  void _onTabRequest() => setState(() => _idx = mainTabNotifier.value);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          // 1. Add Car tab with wizard past step 0 → go back one step
          if (_idx == 3 && addCarStepNotifier.value > 0) {
            addCarStepNotifier.value = addCarStepNotifier.value - 1;
            return;
          }
          // 2. Any tab other than Home → switch to Home
          if (_idx != 0) {
            setState(() => _idx = 0);
            return;
          }
          // 3. Home tab → exit app
          SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: C.bg,
          body: IndexedStack(index: _idx, children: const [
            HomeTab(), SearchTab(), ReelsTab(), AddCarTab(), MessagesTab(), ProfileTab()
          ]),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -3))]),
            child: SafeArea(top: false, child: SizedBox(height: 62, child: Row(children: [
              _BTab(icon: Icons.home_outlined,              active: Icons.home_rounded,            label: T.g('nav_home'),   idx: 0, cur: _idx, onTap: () { setState(() => _idx = 0); mainTabNotifier.value = 0; }),
              _BTab(icon: Icons.search_outlined,             active: Icons.search_rounded,          label: T.g('nav_search'), idx: 1, cur: _idx, onTap: () { setState(() => _idx = 1); mainTabNotifier.value = 1; }),
              _BTab(icon: Icons.play_circle_outline_rounded, active: Icons.play_circle_rounded,     label: 'Reels',          idx: 2, cur: _idx, onTap: () { setState(() => _idx = 2); mainTabNotifier.value = 2; }),
              // Centre Add Car FAB — theme-aware, index 3
              Expanded(child: GestureDetector(
                onTap: () { setState(() => _idx = 3); mainTabNotifier.value = 3; },
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: LinearGradient(colors: _idx == 3
                      ? [ThemeManager.active.primaryLt, ThemeManager.active.primaryDk]
                      : [ThemeManager.active.primary,   ThemeManager.active.primaryDk]),
                    boxShadow: [BoxShadow(color: ThemeManager.active.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 3))]),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 26)),
                  const SizedBox(height: 2),
                  Text(T.g('nav_add'), style: TextStyle(
                    fontSize: 9,
                    color: _idx == 3 ? ThemeManager.active.primary : C.textSub,
                    fontWeight: _idx == 3 ? FontWeight.w700 : FontWeight.w400)),
                ]))),
              _BTab(icon: Icons.chat_bubble_outline_rounded, active: Icons.chat_bubble_rounded,    label: T.g('nav_msgs'),   idx: 4, cur: _idx, onTap: () { setState(() => _idx = 4); mainTabNotifier.value = 4; }, badge: 2),
              _BTab(icon: Icons.person_outline_rounded,      active: Icons.person_rounded,         label: T.g('nav_profile'),idx: 5, cur: _idx, onTap: () { setState(() => _idx = 5); mainTabNotifier.value = 5; }),
            ])))),
        ),
      ),
    );
  }
}

class _BTab extends StatelessWidget {
  final IconData icon, active; final String label;
  final int idx, cur; final VoidCallback onTap; final int badge;
  const _BTab({required this.icon, required this.active, required this.label,
    required this.idx, required this.cur, required this.onTap, this.badge = 0});
  @override
  Widget build(BuildContext context) {
    final sel = idx == cur;
    return Expanded(child: GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(children: [
          Icon(sel ? active : icon, color: sel ? C.primary : const Color(0xFFAAB4CC), size: 24),
          if (badge > 0) Positioned(right: 0, top: 0, child: Container(width: 14, height: 14,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: C.red),
            child: Center(child: Text('$badge',
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white))))),
        ]),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 10,
          color: sel ? C.primary : const Color(0xFFAAB4CC),
          fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
      ])));
  }
}
