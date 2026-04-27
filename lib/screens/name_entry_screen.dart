import 'package:flutter/material.dart';
import '../core/auth.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';
import '../widgets/shared_widgets.dart';
import 'main_shell.dart';

class NameEntryScreen extends StatefulWidget {
  /// If true, pop with `true` instead of pushing MainShell — so the login
  /// wall on the previous screen can resume the original action.
  final bool returnAfterLogin;
  const NameEntryScreen({super.key, this.returnAfterLogin = false});
  @override State<NameEntryScreen> createState() => _NameState();
}
class _NameState extends State<NameEntryScreen> {
  final _ctrl = TextEditingController();
  bool _saving = false;
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (_ctrl.text.trim().length < 2) return;
    setState(() => _saving = true);
    AuthService.setName(_ctrl.text);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    if (widget.returnAfterLogin) {
      Navigator.pop(context, true);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)),
        (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [pri.withOpacity(0.08), Colors.white])),
          child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(children: [
              const SizedBox(height: 50),
              Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, color: pri.withOpacity(0.1)),
                child: Icon(Icons.person_rounded, color: pri, size: 34)),
              const SizedBox(height: 16),
              const Text("What's your name?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.navy)),
              const SizedBox(height: 6),
              const Text('This is how other users will see you on CarPro',
                style: TextStyle(fontSize: 13, color: C.textSub), textAlign: TextAlign.center),
              const SizedBox(height: 28),
              InpField(ctrl: _ctrl, hint: 'Your name', icon: Icons.person_outline_rounded),
              const SizedBox(height: 24),
              PriBtn(label: _saving ? '…' : T.g('continue'), onTap: _saving ? null : _save, loading: _saving),
             ])))))
  }
}
