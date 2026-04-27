import 'package:flutter/material.dart';
import '../core/auth.dart';
import '../core/constants.dart';
import '../core/theme.dart';
// PhoneScreen is imported here to break the circular dep:
// auth.dart does NOT import phone_screen.dart
// login_wall.dart (widgets/) imports both auth and phone_screen safely
import '../screens/phone_screen.dart';

// ═══════════════════════════════════════════════════════════════════
// LOGIN-WALL HELPER
// Wraps any guest-restricted action. If user is logged in, runs it.
// If not, opens a bottom sheet asking them to sign in. After login,
// the original action is replayed automatically (state preservation).
// ═══════════════════════════════════════════════════════════════════

Future<void> requireLogin(BuildContext context, VoidCallback action, {String? reason}) async {
  if (AuthService.isLoggedIn) { action(); return; }
  final didLogin = await showModalBottomSheet<bool>(
    context: context, isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _LoginWall(reason: reason)) ?? false;
  if (didLogin && context.mounted) action();   // replay original action
}

class _LoginWall extends StatelessWidget {
  final String? reason;
  const _LoginWall({this.reason});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: pri.withOpacity(0.1)),
          child: Icon(Icons.lock_outline_rounded, color: pri, size: 28)),
        const SizedBox(height: 14),
        const Text('Sign in to continue', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: C.navy)),
        const SizedBox(height: 4),
        Text(reason ?? 'You need an account to use this feature',
          style: const TextStyle(fontSize: 13, color: C.textSub), textAlign: TextAlign.center),
        const SizedBox(height: 22),
        SizedBox(width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const PhoneScreen(returnAfterLogin: true)));
              if (context.mounted) Navigator.pop(context, result ?? false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: pri, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            child: const Text('Sign In with Phone', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 8),
        TextButton(onPressed: () => Navigator.pop(context, false),
          child: Text('Maybe later', style: TextStyle(color: C.textSub, fontSize: 13))),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ]));
  }
}
