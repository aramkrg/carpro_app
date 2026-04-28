import 'package:flutter/material.dart';
import '../core/app_flags.dart';
import '../core/auth.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';
import '../widgets/shared_widgets.dart';
import 'main_shell.dart';
import 'otp_screen.dart';
import 'registration_type_screen.dart';

class PhoneScreen extends StatefulWidget {
  final bool returnAfterLogin;
  const PhoneScreen({super.key, this.returnAfterLogin = false});
  @override State<PhoneScreen> createState() => _PhoneState();
}
class _PhoneState extends State<PhoneScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    final phone = _ctrl.text.trim();
    if (phone.length < 10) {
      setState(() => _error = 'Please enter a valid phone number');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService.sendOtp(phone);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
        OtpScreen(phone: phone, returnAfterLogin: widget.returnAfterLogin)));
    } catch (e) {
      setState(() => _error = 'Could not send code. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _guest() {
    if (widget.returnAfterLogin) {
      Navigator.pop(context, false);
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Directionality(textDirection: T.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Colors.white,
        appBar: widget.returnAfterLogin ? AppBar(backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close_rounded, color: C.navy),
            onPressed: () => Navigator.pop(context, false))) : null,
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [pri.withOpacity(0.08), Colors.white])),
          child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 26), child: Column(children: [
            const SizedBox(height: 32),
            AppLogoBall(sz: 68),
            const SizedBox(height: 10),
            const Text('CarPro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: C.navy)),
            const SizedBox(height: 24),
            // REQ 8: Registration type choice
            if (!widget.returnAfterLogin) ...[
              _RegTypeRow(pri: pri),
              const SizedBox(height: 20),
            ],
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: pri.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8))]),
              child: Column(children: [
                Container(width: 62, height: 62, decoration: BoxDecoration(shape: BoxShape.circle, color: pri.withOpacity(0.1)),
                  child: Icon(Icons.phone_iphone_rounded, color: pri, size: 28)),
                const SizedBox(height: 12),
                Text(T.g('phone_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.navy)),
                const SizedBox(height: 3),
                Text(T.g('phone_sub'), style: const TextStyle(fontSize: 13, color: C.textSub)),
                const SizedBox(height: 20),
                InpField(hint: T.g('phone_hint'), icon: Icons.phone_outlined, ctrl: _ctrl, kbType: TextInputType.phone),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.error_outline_rounded, color: C.red, size: 14),
                    const SizedBox(width: 4),
                    Text(_error!, style: const TextStyle(color: C.red, fontSize: 12))]),
                ],
                const SizedBox(height: 18),
                PriBtn(label: _loading ? '…' : T.g('send_code'), onTap: _loading ? null : _send, loading: _loading),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Row(children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: Colors.amber),
                    SizedBox(width: 6),
                    Expanded(child: Text('Test mode: any phone works. OTP code is 123456',
                      style: TextStyle(fontSize: 11, color: Color(0xFF8B6914)))),
                  ])),
              ])),
            const SizedBox(height: 18),
            if (AppFlags.guestBrowsing && !widget.returnAfterLogin) GestureDetector(onTap: _guest,
              child: Text(T.g('browse_guest'), style: TextStyle(color: pri, fontSize: 14, fontWeight: FontWeight.w600))),
            const SizedBox(height: 30),
          ]))))));
  }
}

/// REQ 8: Registration type selector (Normal / Dealer)
class _RegTypeRow extends StatefulWidget {
  final Color pri;
  const _RegTypeRow({required this.pri});
  @override State<_RegTypeRow> createState() => _RegTypeRowState();
}
class _RegTypeRowState extends State<_RegTypeRow> {
  String _type = 'normal';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('I am registering as:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.navy)),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _type = 'normal'),
          child: AnimatedContainer(duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _type == 'normal' ? widget.pri : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _type == 'normal' ? widget.pri : C.border),
              boxShadow: _type == 'normal' ? [BoxShadow(color: widget.pri.withOpacity(0.2), blurRadius: 8)] : null),
            child: Column(children: [
              Icon(Icons.person_rounded, color: _type == 'normal' ? Colors.white : C.textSub, size: 26),
              const SizedBox(height: 4),
              Text('Private Seller', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: _type == 'normal' ? Colors.white : C.textMain)),
              Text('Buy & Sell Cars', style: TextStyle(fontSize: 10,
                color: _type == 'normal' ? Colors.white70 : C.textSub)),
            ])))),
        const SizedBox(width: 10),
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() => _type = 'dealer');
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DealerRegistrationScreen()));
          },
          child: AnimatedContainer(duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _type == 'dealer' ? const Color(0xFFFF8F00) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _type == 'dealer' ? const Color(0xFFFF8F00) : C.border),
              boxShadow: _type == 'dealer' ? [BoxShadow(color: const Color(0xFFFF8F00).withOpacity(0.2), blurRadius: 8)] : null),
            child: Column(children: [
              Icon(Icons.storefront_rounded, color: _type == 'dealer' ? Colors.white : C.textSub, size: 26),
              const SizedBox(height: 4),
              Text('Dealer/Showroom', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: _type == 'dealer' ? Colors.white : C.textMain)),
              Text('Business Account', style: TextStyle(fontSize: 10,
                color: _type == 'dealer' ? Colors.white70 : C.textSub)),
            ])))),
      ]),
    ]);
  }
}
