import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/auth.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';
import '../widgets/shared_widgets.dart';
import 'main_shell.dart';
import 'name_entry_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  /// If true, on success pop with `true` so the login wall can replay the action.
  final bool returnAfterLogin;
  const OtpScreen({super.key, required this.phone, this.returnAfterLogin = false});
  @override State<OtpScreen> createState() => _OtpState();
}
class _OtpState extends State<OtpScreen> {
  final _boxes = List.generate(6, (_) => TextEditingController());
  final _foci  = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  String? _error;
  int _cd = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_cd > 0) {
        setState(() => _cd--);
      } else {
        _timer.cancel();
      }
    });
  }
  @override void dispose() {
    for (var x in _boxes) {
      x.dispose();
    }
    for (var x in _foci) {
      x.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _boxes.map((b) => b.text).join();
    if (code.length < 6) return;
    setState(() { _loading = true; _error = null; });
    final ok = await AuthService.verifyOtp(code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!ok) {
      setState(() => _error = 'Wrong code. Try 123456 (test mode)');
      return;
    }
    final user = AuthService.current!;
    // New user (no name yet) → go to NameEntryScreen
    if (user.name.isEmpty) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => NameEntryScreen(returnAfterLogin: widget.returnAfterLogin)));
      if (!mounted) return;
      if (widget.returnAfterLogin) {
        Navigator.pop(context, result ?? true);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
      }
      return;
    }
    // Existing user → straight to home (or back to caller for state preservation)
    if (widget.returnAfterLogin) {
      Navigator.pop(context, true);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy, size: 20),
            onPressed: () => Navigator.pop(context))),
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [pri.withOpacity(0.08), Colors.white])),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 26), child: Column(children: [
            const SizedBox(height: 16),
            Container(width: 62, height: 62, decoration: BoxDecoration(shape: BoxShape.circle, color: pri.withOpacity(0.1)),
              child: Icon(Icons.sms_outlined, color: pri, size: 28)),
            const SizedBox(height: 12),
            Text(T.g('otp_title'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.navy)),
            const SizedBox(height: 4),
            Text('${T.g('otp_sub')} ${widget.phone}',
              style: const TextStyle(fontSize: 13, color: C.textSub), textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => SizedBox(width: 46, height: 56,
                child: TextField(
                  controller: _boxes[i], focusNode: _foci[i],
                  keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.navy),
                  decoration: InputDecoration(counterText: '', filled: true, fillColor: const Color(0xFFF4F7FF),
                    border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: pri, width: 2))),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) _foci[i + 1].requestFocus();
                    if (v.isEmpty   && i > 0) _foci[i - 1].requestFocus();
                    if (i == 5 && v.isNotEmpty) _verify(); // auto-submit on last digit
                  })))),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: C.red, fontSize: 12)),
            ],
            const SizedBox(height: 26),
            PriBtn(label: T.g('verify'), onTap: _loading ? null : _verify, loading: _loading),
            const SizedBox(height: 16),
            _cd > 0
              ? Text('${T.g('resend_in')} $_cd${T.g('s')}',
                  style: const TextStyle(color: C.textSub, fontSize: 13))
              : GestureDetector(
                  onTap: () async {
                    await AuthService.sendOtp(widget.phone);
                    setState(() => _cd = 30);
                    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                      if (_cd > 0) {
                        setState(() => _cd--);
                      } else {
                        _timer.cancel();
                      }
                    });
                  },
                  child: Text(T.g('resend'), style: TextStyle(color: pri, fontWeight: FontWeight.w600, fontSize: 14))),
          ])))));
  }
}
