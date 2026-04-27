import 'package:flutter/material.dart';
import '../../core/app_flags.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';
import '../../core/theme.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});
  @override State<ThemeScreen> createState() => _ThemeScreenState();
}
class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    // Apply admin allow-list filter
    final available = AppFlags.allowedThemeIds.isEmpty
      ? Themes.user
      : Themes.user.where((t) => AppFlags.allowedThemeIds.contains(t.id)).toList();
    final activeEvent = AppFlags.eventThemesEnabled ? ThemeManager.activeEventTheme() : null;

    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: ThemeManager.active.bg,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context)),
          title: const Text('Theme',
            style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 18)),
          centerTitle: true),
        body: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 32), children: [
          // Active event banner — shown when an event window is open
          if (activeEvent != null) ...[
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: [activeEvent.primary, activeEvent.primaryDk]),
                boxShadow: [BoxShadow(color: activeEvent.primary.withOpacity(0.3),
                  blurRadius: 14, offset: const Offset(0, 4))]),
              child: Row(children: [
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                  child: Icon(activeEvent.icon, color: Colors.white, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(activeEvent.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                  const Text('Festival theme is active. Your custom theme will resume after the event.',
                    style: TextStyle(fontSize: 11, color: Colors.white70)),
                ])),
              ])),
            const SizedBox(height: 16),
          ],
          // Section: Glass themes
          const Padding(padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('Glass Themes',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.textSub, letterSpacing: 0.5))),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
            itemCount: available.length,
            itemBuilder: (_, i) {
              final t = available[i];
              final isActive = ThemeManager.userPickId == t.id && activeEvent == null;
              return _ThemeCard(theme: t, isActive: isActive,
                onTap: () { ThemeManager.setUserPick(t.id); setState(() {}); });
            }),
          const SizedBox(height: 20),
          // Upcoming events — informational only
          if (AppFlags.eventThemesEnabled) ...[
            const Padding(padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text('Upcoming Festival Themes',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.textSub, letterSpacing: 0.5))),
            ...ThemeManager.scheduledEvents.map((ev) {
              final mm = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
              final label = '${mm[ev.start.month - 1]} ${ev.start.day} – ${mm[ev.end.month - 1]} ${ev.end.day}';
              final isLive = DateTime.now().isAfter(ev.start) && DateTime.now().isBefore(ev.end);
              return Container(margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
                child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: ev.theme.primary.withOpacity(0.12)),
                    child: Icon(ev.theme.icon, color: ev.theme.primary, size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(ev.theme.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.navy)),
                    Text(label, style: const TextStyle(fontSize: 11, color: C.textSub)),
                  ])),
                  if (isLive) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: ev.theme.primary, borderRadius: BorderRadius.circular(5)),
                    child: const Text('LIVE',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white))),
                ]));
            }),
          ],
        ]),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final AppTheme theme;
  final bool isActive;
  final VoidCallback onTap;
  const _ThemeCard({required this.theme, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? theme.primary : C.border, width: isActive ? 2.5 : 1.2),
          boxShadow: [BoxShadow(
            color: isActive ? theme.primary.withOpacity(0.25) : Colors.black.withOpacity(0.04),
            blurRadius: 14, offset: const Offset(0, 4))]),
        child: Stack(children: [
          // Visual preview — gradient with icon
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [theme.primary, theme.primaryDk])),
            child: Stack(children: [
              Positioned(right: -10, bottom: -10,
                child: Icon(theme.icon, size: 110, color: Colors.white.withOpacity(0.15))),
              Padding(padding: const EdgeInsets.all(14), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                    child: Icon(theme.icon, color: Colors.white, size: 20)),
                  Text(theme.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                ]))]),
          ),
          if (isActive) Positioned(top: 8, right: 8, child: Container(width: 26, height: 26,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Icon(Icons.check_rounded, color: theme.primary, size: 18))),
        ]),
      ),
    );
  }
}
