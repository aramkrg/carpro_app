import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/translations.dart';
import '../core/theme.dart';

// ═══════════════════════════════════════════════════════════════════
// SHARED WIDGETS — used across multiple screens
// ═══════════════════════════════════════════════════════════════════

class AppLogoBall extends StatelessWidget {
  final double sz; final bool dark;
  const AppLogoBall({super.key, required this.sz, this.dark = false});
  @override
  Widget build(BuildContext context) => Container(width: sz, height: sz,
    decoration: BoxDecoration(shape: BoxShape.circle,
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)]),
      boxShadow: [BoxShadow(color: C.primary.withOpacity(dark ? 0.5 : 0.3), blurRadius: sz * 0.26, offset: Offset(0, sz * 0.06))]),
    child: Center(child: Icon(Icons.directions_car_rounded, color: Colors.white, size: sz * 0.44)));
}

/// Simple app bar with title, search, and notifications icons.
class AppBar2 extends StatelessWidget {
  final String title;
  const AppBar2({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Container(color: Colors.white,
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: SizedBox(height: 56, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.navy))),
        IconButton(icon: const Icon(Icons.search_rounded,        color: C.navy, size: 22), onPressed: () {}),
        IconButton(icon: const Icon(Icons.notifications_outlined, color: C.navy, size: 22), onPressed: () {}),
      ]))));
}

/// Full-width primary button, theme-aware color.
class PriBtn extends StatelessWidget {
  final String label; final VoidCallback? onTap; final bool loading;
  const PriBtn({super.key, required this.label, this.onTap, this.loading = false});
  @override
  Widget build(BuildContext context) {
    final pri = ThemeManager.active.primary;
    return SizedBox(width: double.infinity, height: 52,
      child: ElevatedButton(onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: pri, disabledBackgroundColor: const Color(0xFFDDE4F0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          elevation: 3, shadowColor: pri.withOpacity(0.35)),
        child: loading
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
              color: onTap != null ? Colors.white : const Color(0xFFAAB4CC)))));
  }
}

/// Full-width white outline button for use on dark backgrounds (splash screen).
class OutlineWhiteBtn extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const OutlineWhiteBtn({super.key, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 52,
    child: OutlinedButton(onPressed: onTap,
      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70))));
}

/// Text field with controller (used in Phone, OTP, Name Entry screens).
class InpField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final TextInputType kbType;
  final bool obscure;
  const InpField({super.key, required this.ctrl, required this.hint, required this.icon,
    this.kbType = TextInputType.text, this.obscure = false});
  @override
  Widget build(BuildContext context) => TextField(controller: ctrl, obscureText: obscure, keyboardType: kbType,
    textAlign: T.isRTL ? TextAlign.right : TextAlign.left,
    style: const TextStyle(fontSize: 15, color: C.navy),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: Color(0xFFBBC4D8), fontSize: 14),
      prefixIcon: Icon(icon, color: C.primary, size: 20),
      filled: true, fillColor: const Color(0xFFF4F7FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.primary, width: 1.8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)));
}

/// Text field without controller (used in form steps, tools).
class IFld extends StatelessWidget {
  final String hint; final IconData icon; final TextInputType kbType;
  const IFld({super.key, required this.hint, required this.icon, this.kbType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(keyboardType: kbType,
    textAlign: T.isRTL ? TextAlign.right : TextAlign.left,
    style: const TextStyle(fontSize: 15, color: C.navy),
    decoration: InputDecoration(
      hintText: hint, hintStyle: const TextStyle(color: Color(0xFFBBC4D8), fontSize: 14),
      prefixIcon: Icon(icon, color: C.primary, size: 20),
      filled: true, fillColor: const Color(0xFFF4F7FF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: C.primary, width: 1.8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)));
}

/// Form label above a field.
class FL extends StatelessWidget {
  final String t; const FL(this.t, {super.key});
  @override
  Widget build(BuildContext context) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.textMain));
}

/// Dropdown used in forms and filters.
class FDrop extends StatelessWidget {
  final String val; final List<String> items; final ValueChanged<String?> onChanged;
  const FDrop({super.key, required this.val, required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final v = items.contains(val) ? val : items.first;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF4F7FF), borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        value: v, isExpanded: true,
        icon: const Icon(Icons.expand_more_rounded, color: C.textSub, size: 18),
        style: const TextStyle(fontSize: 14, color: C.textMain, fontFamily: 'Roboto'),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: onChanged)));
  }
}

// ─── Private aliases used within this package only ─────────────────
// These allow screens still using the old _ prefix names to compile
// while we update them. They are thin wrappers; no logic change.
// ignore_for_file: unused_element
typedef _LogoBall = AppLogoBall;
typedef _AppBar2 = AppBar2;
typedef _PriBtn = PriBtn;
typedef _OutlineWhiteBtn = OutlineWhiteBtn;
typedef _InpField = InpField;
typedef _IFld = IFld;
typedef _FL = FL;
typedef _FDrop = FDrop;
